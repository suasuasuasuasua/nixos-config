# glances provides a quick overview on system resource usage and processes
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "glances";
  cfg = config.services.${serviceName};
in
{
  services.glances = {
    enable = true;

    port = infra.ports.glances;
    extraArgs = [
      "--webserver"
    ];
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };
    };
  };
}
