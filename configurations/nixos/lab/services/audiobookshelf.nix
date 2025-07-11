# audiobookshelf is a self hosted audiobook manager application
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "audiobookshelf";

  # default = 8000
  port = 8000;
in
{
  services.audiobookshelf = {
    inherit port;

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
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
