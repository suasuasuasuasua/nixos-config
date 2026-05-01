# https://wiki.nixos.org/wiki/Prowlarr
# prowlarr is an indexer manager for the *arr stack
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "prowlarr";
in
{
  services.prowlarr = {
    enable = true;
    settings.server.port = infra.ports.prowlarr;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.prowlarr}";
        proxyWebsockets = true;
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
