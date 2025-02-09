{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  # default port = 5055
  port = 5055;
  serviceName = "jellyseerr";
in
{
  services.jellyseerr = {
    enable = true;
    port = port;
    openFirewall = true;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
