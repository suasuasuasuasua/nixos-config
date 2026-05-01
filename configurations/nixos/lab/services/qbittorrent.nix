# qbittorrent is the download client used by the *arr stack
# download directory: /zshare/media/downloads (configure via web UI)
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "qbittorrent";
in
{
  services.qbittorrent = {
    enable = true;
    webuiPort = infra.ports.qbittorrent;
    serverConfig = { };
  };

  users.users.qbittorrent.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.qbittorrent}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
