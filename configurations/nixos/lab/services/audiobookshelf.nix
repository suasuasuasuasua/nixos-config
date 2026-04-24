# audiobookshelf is a self hosted audiobook manager application
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "audiobookshelf";
in
{
  services.audiobookshelf = {
    port = infra.ports.audiobookshelf;

    enable = true;
    host = "127.0.0.1";
  };

  users.users.audiobookshelf.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.audiobookshelf}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
