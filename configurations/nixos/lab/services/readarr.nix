# https://wiki.nixos.org/wiki/Readarr
# readarr is a book/ebook collection manager
# configure root folder to /zshare/media/books via the web UI
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "readarr";
in
{
  services.readarr = {
    enable = true;
    settings.server.port = infra.ports.readarr;
  };

  users.users.readarr.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.readarr}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
