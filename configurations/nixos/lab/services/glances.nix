# glances provides a quick overview on system resource usage and processes
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "glances";
  cfg = config.services.${serviceName};

  # default = 61208
  port = 61208;
in
{
  services.glances = {
    inherit port;

    enable = true;
    extraArgs = [
      "--webserver"
    ];
  };

  services.nginx.virtualHosts = {
    "${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.port}";
      };

      serverAliases = [
        "${hostName}.${domain}"
        "${serviceName}.${hostName}.${domain}"
      ];
    };
  };
}
