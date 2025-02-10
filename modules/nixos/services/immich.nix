{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  # default port = 2283
  port = 2283;
  serviceName = "immich";
in
{
  services.immich = {
    enable = true;
    port = port;
    openFirewall = true;

    mediaLocation = "/zshare/personal/images/";
    machine-learning.enable = true;
    settings = { };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          "client_max_body_size 0;";
      };
    };
  };
}
