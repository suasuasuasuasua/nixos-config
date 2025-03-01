{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "wastebin";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Wastebin";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8088;
    };
  };

  config = lib.mkIf cfg.enable {
    # no option to open firewall so do it manually!
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.wastebin = {
      enable = true;
      settings = {
        WASTEBIN_ADDRESS_PORT = "0.0.0.0:${toString cfg.port}";
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
