{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  # default port = 8096
  port = 8096;
  serviceName = "jellyfin";

  cfg = config.services.custom.${serviceName};
in
{
  options.services.custom.${serviceName} = {
    enable = lib.mkEnableOption "Enable Jellyfin";
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      # no option to change port...
      # port = 8096
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
