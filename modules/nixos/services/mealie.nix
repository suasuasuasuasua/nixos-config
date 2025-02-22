{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "mealie";
  port = 9000;

  cfg = config.services.custom.${serviceName};
in
{
  options.services.custom.${serviceName} = {
    enable = lib.mkEnableOption "Enable Adguard Home";
  };

  config = lib.mkIf cfg.enable {
    # no option to open firewall so do it manually!
    networking.firewall.allowedTCPPorts = [
      9000
    ];

    services.mealie = {
      enable = true;
      # default port = 9000
      port = port;
      settings = { };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
