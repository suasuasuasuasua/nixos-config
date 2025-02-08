{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "glances";
  port = 61208;
in
{
  services.glances = {
    enable = true;
    port = port;
    openFirewall = true;
    extraArgs = [
      "--webserver"
    ];
  };

  # System
  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        # System overview
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };

}
