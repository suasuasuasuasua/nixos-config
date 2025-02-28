{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  # default port = 5055
  port = 5055;
  serviceName = "jellyseerr";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Jellyseerr";
  };

  config = lib.mkIf cfg.enable {
    services.jellyseerr = {
      enable = true;
      inherit port;
      openFirewall = true;
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # Jellyfin Media
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
