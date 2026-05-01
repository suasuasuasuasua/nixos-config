# https://wiki.nixos.org/wiki/Radarr
# radarr is a movie collection manager
# configure root folder to /zshare/media/movies via the web UI
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "radarr";
in
{
  services.radarr = {
    enable = true;
    settings.server.port = infra.ports.radarr;
  };

  users.users.radarr.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.radarr}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
