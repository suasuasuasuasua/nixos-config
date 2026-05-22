# https://wiki.nixos.org/wiki/Lidarr
# lidarr is a music collection manager
# configure root folder to /zshare/media/music via the web UI
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "lidarr";
in
{
  services.lidarr = {
    enable = true;
    settings.server.port = infra.ports.lidarr;
  };

  users.users.lidarr.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.lidarr}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
