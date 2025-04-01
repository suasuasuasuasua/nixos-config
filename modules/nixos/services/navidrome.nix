{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "navidrome";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Navidrome Music Server and Streamer compatible with Subsonic/Airsonic
    '';
    Port = lib.mkOption {
      type = lib.types.port;
      default = 4533;
    };
    MusicFolder = lib.mkOption {
      type = lib.types.path;
      default = "";
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      openFirewall = true;

      settings = {
        inherit (cfg) Port MusicFolder;

        Address = "127.0.0.1";
        EnableInsightsCollector = false;
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.Port}";
        };
      };
    };
  };
}
