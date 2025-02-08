{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "dashy";
in
{
  services.dashy = {
    enable = true;
    # option does not exist :(
    # port = 8080;
    virtualHost.enableNginx = true;
    virtualHost.domain = "${serviceName}.${hostName}.home";
  };
}
