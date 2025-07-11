# https://wiki.nixos.org/wiki/Uptime_Kuma
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "uptime-kuma";

  port = 4000;
in
{
  services.uptime-kuma = {
    enable = true;

    appriseSupport = true;
    settings = {
      UPTIME_KUMA_PORT = toString port;
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };

      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };
  };
}
