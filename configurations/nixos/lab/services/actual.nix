# actual is a self hosted budgeting application
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "actual";
in
{
  services.actual = {
    enable = true;
    settings.port = infra.ports.actual;
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.actual}";

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
