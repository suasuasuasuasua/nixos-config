# glances provides a quick overview on system resource usage and processes
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "glances";
in
{
  services.glances = {
    port = infra.ports.glances;

    enable = true;
    extraArgs = [ "--webserver" ];
  };

  services.nginx.virtualHosts."${serviceName}.${hostName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://127.0.0.1:${toString infra.ports.glances}";
  };
}
