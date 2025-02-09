{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "wastebin";
  port = 8088;
in
{
  # no option to open firewall so do it manually!
  networking.firewall.allowedTCPPorts = [
    port
  ];

  services.wastebin = {
    enable = true;
    settings = {
      WASTEBIN_ADDRESS_PORT = "0.0.0.0:${toString port}";
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
