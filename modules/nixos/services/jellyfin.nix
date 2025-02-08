{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  port = 8096;
in
{
  services.jellyfin = {
    enable = true;
    # no option to change port...
    # port = 8096
    openFirewall = true;
  };
  services.nginx.virtualHosts = {
    "jellyfin.${hostName}.home" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
