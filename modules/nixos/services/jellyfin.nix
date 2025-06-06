{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
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

    environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
    ];

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
