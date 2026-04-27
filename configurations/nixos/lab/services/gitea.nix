# gitea is a self hosted git repository
{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitea";

  stateDir = "/zshare/srv/gitea";
  tokenFile = config.sops.secrets."gitea/token".path;
  signingKeyPub = config.sops.secrets."gitea/signing-key.pub".path;

  # Custom runner image: Nix (flakes enabled) + Node.js for JS-based actions
  runnerImage = pkgs.dockerTools.buildLayeredImage {
    name = "gitea-runner-nix";
    tag = "latest";
    contents = with pkgs; [
      nix
      nodejs
      bash
      coreutils
      curl
      git
      cacert
      gnutar
      gzip
      xz
    ];
    config = {
      Env = [
        "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        "NIX_CONFIG=${''
          experimental-features = nix-command flakes
          build-users-group =
        ''}"
      ];
    };
  };
in
{
  sops.secrets = {
    "gitea/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "gitea/signing-key" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
      owner = config.services.gitea.user;
      mode = "0400";
    };
    "gitea/signing-key.pub" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
      owner = config.services.gitea.user;
    };
  };

  services = {
    gitea = {
      inherit stateDir;

      enable = true;
      lfs.enable = true;

      settings = {
        server = {
          DOMAIN = "${serviceName}.${domain}";
          HTTP_PORT = infra.ports.gitea.http;
          START_SSH_SERVER = true;
          SSH_PORT = infra.ports.gitea.ssh;
          SSH_LISTEN_PORT = infra.ports.gitea.ssh;
          ROOT_URL = "https://${serviceName}.${domain}";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
        session = {
          COOKIE_SECURE = true;
        };
        repository = {
          ENABLE_PUSH_CREATE_USER = true;
          ENABLE_PUSH_CREATE_ORG = true;
        };
        "repository.signing" = {
          # Points to .pub file; git looks for private key at same path minus .pub
          # i.e. /run/secrets/gitea/signing-key (also a sops secret)
          SIGNING_KEY = signingKeyPub;
          SIGNING_NAME = "gitea";
          SIGNING_EMAIL = "gitea@gitea.sua.dev";
          SIGNING_FORMAT = "ssh";
          INITIAL_COMMIT = "always";
          CRUD_ACTIONS = "pubkey, twofa, parentsigned";
          WIKI = "never";
          MERGES = "pubkey, twofa, basesigned, commitssigned";
        };
        security = {
          # Two proxy hops: lab nginx (127.0.0.1) + VPS0 nginx (10.101.0.1 over WireGuard).
          # Without trusting both, Gitea attributes all requests to VPS0's WireGuard IP,
          # causing fail2ban to ban VPS0 instead of real attackers.
          REVERSE_PROXY_LIMIT = 2;
          REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.1/8,${infra.vps0.wg1IP}/32";
        };
        indexer = {
          REPO_INDEXER_ENABLED = true;
          REPO_INDEXER_PATH = "indexers/repos.bleve";
          MAX_FILE_SIZE = 1048576;
          REPO_INDEXER_INCLUDE = "";
          REPO_INDEXER_EXCLUDE = "resources/bin/**";
        };
      };
    };

    gitea-actions-runner.instances = {
      default = {
        inherit tokenFile;

        url = "https://${serviceName}.${domain}";
        name = hostName;
        enable = true;
        labels = [
          # provide a debian base with nodejs for actions
          "debian-latest:docker://node:24-trixie"
          # fake the ubuntu name, because node provides no ubuntu builds
          "ubuntu-latest:docker://node:24-trixie"
          # ephemeral nix container for nix/nixos workflows (pulled from local registry)
          "nix:docker://localhost:${toString infra.ports.dockerRegistry}/gitea-runner-nix:latest"
        ];
        settings = {
          runner.capacity = 2;
        };
      };
    };
  };

  # Container registry for lab and VPS1 runners.
  # Bound to 0.0.0.0 so both localhost (lab runner) and 10.101.0.2 (VPS1 over WireGuard) can reach it.
  # Port 5002 is only opened on wg1 in wireguard/default.nix, so it's not exposed publicly.
  services.dockerRegistry = {
    enable = true;

    listenAddress = "0.0.0.0";
    enableGarbageCollect = true;
    garbageCollectDates = "daily";
    port = infra.ports.dockerRegistry;
  };

  # Load the runner image into podman and push it to the local registry.
  # Runs before the runner starts and re-runs whenever the image derivation changes.
  systemd.services.load-gitea-runner-image = {
    description = "Load and publish gitea runner OCI image";
    wantedBy = [ "gitea-runner-lab-runner.service" ];
    after = [ "docker-registry.service" ];
    requires = [ "docker-registry.service" ];
    before = [ "gitea-runner-lab-runner.service" ];
    restartTriggers = [ runnerImage ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "load-gitea-runner-image" ''
        ${pkgs.podman}/bin/podman load -i ${runnerImage}
        ${pkgs.podman}/bin/podman push --tls-verify=false gitea-runner-nix:latest localhost:${toString infra.ports.dockerRegistry}/gitea-runner-nix:latest
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ infra.ports.gitea.ssh ];

  environment.systemPackages = with pkgs; [
    gitea # gitea command line interface
  ];

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString infra.ports.gitea.http}";
      proxyWebsockets = true;
      extraConfig = "client_max_body_size 0;";
    };
    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
