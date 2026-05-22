# https://wiki.nixos.org/wiki/Bazarr
# bazarr is a subtitle manager that integrates with sonarr and radarr
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "bazarr";
in
{
  services.bazarr = {
    enable = true;
    listenPort = infra.ports.bazarr;
  };

  users.users.bazarr.extraGroups = [ "samba" ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.bazarr}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
