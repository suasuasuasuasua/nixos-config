{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitea";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Git with a cup of tea
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 5001;
    };
    stateDir = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitea = {
      inherit (cfg) stateDir;

      enable = true;
      lfs.enable = true;

      settings = {
        server = {
          DOMAIN = "${hostName}.${domain}";
          HTTP_PORT = cfg.port;
        };
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

          extraConfig =
            # allow for larger file uploads like videos through the reverse proxy
            "client_max_body_size 0;";
        };
      };
    };
  };
}
