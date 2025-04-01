{ config, lib, ... }:
let
  inherit (config.networking) hostName;
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
      openFirewall = true;
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
