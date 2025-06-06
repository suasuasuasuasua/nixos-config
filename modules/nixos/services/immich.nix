{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "immich";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Self-hosted photo and video backup solution
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 2283;
    };
    mediaLocation = lib.mkOption {
      type = lib.types.path;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      inherit (cfg) port mediaLocation;

      enable = true;
      machine-learning.enable = true;
      settings = { };
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
