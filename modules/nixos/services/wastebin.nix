{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
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
    services.wastebin = {
      enable = true;
      settings = {
        WASTEBIN_ADDRESS_PORT = "0.0.0.0:${toString cfg.port}";
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
