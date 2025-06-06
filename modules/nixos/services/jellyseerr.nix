{ config, lib, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "jellyseerr";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Fork of overseerr for jellyfin support
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      inherit (cfg) port;

      enable = true;
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
