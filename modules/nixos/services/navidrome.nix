{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "navidrome";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Navidrome";
    Port = lib.mkOption {
      type = lib.type.port;
      default = 4533;
    };
    MusicFolder = lib.mkOption {
      type = lib.type.path;
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
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };
  };
}
