{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "jellyfin";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Free Software Media System
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 8096;
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
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
