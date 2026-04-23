# gitea is a self hosted git repository
{
  config,
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

  # default = 3000
  port = 3001;

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
        "NIX_CONFIG=experimental-features = nix-command flakes\nbuild-users-group ="
      ];
    };
  };
in
{
  services = {
    gitea = {
      inherit stateDir;

      enable = true;
      lfs.enable = true;

      settings = {
        server = {
          DOMAIN = "${serviceName}.${domain}";
          HTTP_PORT = port;
          START_SSH_SERVER = true;
          SSH_PORT = 2222;
          SSH_LISTEN_PORT = 2222;
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
          # Required for fail2ban to see real client IPs (not 127.0.0.1) when behind nginx
          REVERSE_PROXY_LIMIT = 1;
          REVERSE_PROXY_TRUSTED_PROXIES = "127.0.0.1/8";
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
      lab-runner = {
        inherit tokenFile;

        url = "https://${serviceName}.${domain}";
        name = hostName;
        enable = true;
        labels = [
          # provide a debian base with nodejs for actions
          "debian-latest:docker://node:25-trixie"
          # fake the ubuntu name, because node provides no ubuntu builds
          "ubuntu-latest:docker://node:25-trixie"
          # ephemeral nix container for nix/nixos workflows (locally built image)
          "nix:docker://localhost/gitea-runner-nix:latest"
        ];
        settings = {
          runner.capacity = 4;
        };
      };
    };
  };

  # Load the custom runner image into Podman before the runner starts.
  # No RemainAfterExit so this re-runs on every runner restart, ensuring
  # the image is always present (e.g. after a NixOS rebuild).
  systemd.services.load-gitea-runner-image = {
    description = "Load gitea runner OCI image into podman";
    wantedBy = [ "gitea-runner-lab-runner.service" ];
    before = [ "gitea-runner-lab-runner.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman load -i ${runnerImage}";
    };
  };

  networking.firewall.allowedTCPPorts = [ 2222 ];

  environment.systemPackages = with pkgs; [
    gitea # gitea command line interface
  ];

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

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
      extraConfig = "client_max_body_size 0;";
    };
    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
