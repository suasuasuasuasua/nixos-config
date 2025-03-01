{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "immich";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Adguard Home";
    port = lib.mkOption {
      type = lib.type.port;
      default = 61208;
    };
    mediaLocation = lib.mkOption {
      type = lib.type.path;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      inherit (cfg) port mediaLocation;

      enable = true;
      openFirewall = true;
      machine-learning.enable = true;
      settings = { };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
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
