{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "navidrome";
  port = 4533;

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Navidrome";
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      openFirewall = true;

      settings = {
        Port = port;
        Address = "127.0.0.1";
        EnableInsightsCollector = false;

        MusicFolder = "/zshare/media/music";
      };
    };

    services.nginx.virtualHosts = {
      # Media
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # Music Streaming
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
