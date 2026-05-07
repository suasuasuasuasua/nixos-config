# termix is a web based terminal ssh manager
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "termix";
in
{
  imports = [ ./compose.nix ];

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.termix}";

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
