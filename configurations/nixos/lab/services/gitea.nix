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

  # default = 3000
  port = 3001;
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
          ROOT_URL = "https://${serviceName}.${domain}";
        };
        service = {
          DISABLE_REGISTRATION = true;
        };
        session = {
          COOKIE_SECURE = true;
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
          "debian-latest:docker://node:18-bullseye"
          # fake the ubuntu name, because node provides no ubuntu builds
          "ubuntu-latest:docker://node:18-bullseye"
          # provide native execution on the host
          "native:host"
        ];
        settings = { };
        hostPackages = with pkgs; [
          bash
          coreutils
          curl
          gawk
          gitMinimal
          gnused
          nodejs
          wget
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gitea # gitea command line interface
  ];

  sops.secrets = {
    "gitea/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
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

    # Listens only on the WireGuard interface (wg1) so the VPS can proxy here
    # over the tunnel without knowing internal port numbers. No SSL needed —
    # the WireGuard tunnel already encrypts transit, and the VPS terminates
    # TLS for the public internet.
    "${serviceName}-wg.${domain}" = {
      serverName = "${serviceName}.${domain}";
      listen = [
        {
          addr = "10.101.0.2";
          port = 80;
          ssl = false;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = "client_max_body_size 0;";
      };
    };
  };
}
