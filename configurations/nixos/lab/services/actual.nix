# actual is a self hosted budgeting application
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "actual";

  # default = 3000
  port = 3000;
in
{
  services.actual = {
    enable = true;
    settings = {
      inherit port;
    };
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
