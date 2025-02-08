{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "actual";
  port = 3001;
in
{
  # TODO: need to setup HTTPS to continue using...
  services.actual = {
    enable = true;
    openFirewall = true;
    settings = {
      # default port is 3000
      port = port;
    };
  };
  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        # Actual finance planner
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
