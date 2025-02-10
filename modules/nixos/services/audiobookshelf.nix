{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  # default port = 8000
  port = 8000;
  serviceName = "audiobookshelf";
in
{
  services.audiobookshelf = {
    enable = true;
    host = "127.0.0.1";
    port = port;
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
}
