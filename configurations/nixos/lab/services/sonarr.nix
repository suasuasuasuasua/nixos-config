# https://wiki.nixos.org/wiki/Sonarr
# sonarr is a TV show collection manager
# configure root folder to /zshare/media/shows via the web UI
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "sonarr";
in
{
  services.sonarr = {
    enable = true;
    settings.server.port = infra.ports.sonarr;
  };

  users.users.sonarr.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.sonarr}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
