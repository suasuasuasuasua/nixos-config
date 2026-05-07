# mealie is a self hosted recipe manager
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "mealie";
in
{
  services.mealie = {
    enable = true;

    port = infra.ports.mealie;
    settings = { };
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.mealie}";

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
