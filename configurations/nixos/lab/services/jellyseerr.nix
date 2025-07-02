# jellyseerr is a jellyfin companion app that allows users to request content
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "jellyseerr";

  # default = 5055;
  port = 5055;
in
{
  services.jellyseerr = {
    inherit port;

    enable = true;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
