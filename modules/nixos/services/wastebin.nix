{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "wastebin";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Wastebin is a pastebin
    '';
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
