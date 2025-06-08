{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "vaultwarden";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Unofficial Bitwarden compatible server written in Rust
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8222;
    };
    environmentFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      inherit (cfg) environmentFile;

      enable = true;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
        DOMAIN = "https://${serviceName}.${hostName}.${domain}";

        ROCKET_LOG = "critical";
        SIGNUPS_ALLOWED = true;
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };
    };
  };
}
