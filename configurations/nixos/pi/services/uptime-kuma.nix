# https://wiki.nixos.org/wiki/Uptime_Kuma
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "uptime-kuma";
in
{
  services.uptime-kuma = {
    enable = true;

    appriseSupport = true;
    settings.UPTIME_KUMA_PORT = toString infra.ports.uptime-kuma;
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://localhost:${toString infra.ports.uptime-kuma}";
      proxyWebsockets = true; # needed if you need to use WebSocket
    };

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
