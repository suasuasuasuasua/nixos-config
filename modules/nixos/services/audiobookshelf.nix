{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  # default port = 8000
  port = 8000;
  serviceName = "audiobookshelf";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Audiobook Shelf";
  };

  config = lib.mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      host = "127.0.0.1";
      inherit port;
      openFirewall = true;
    };

    # Networking
    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # audiobook manager
          proxyPass = "http://localhost:${toString port}";
          proxyWebsockets = true; # needed if you need to use WebSocket
        };
      };
    };
  };
}
