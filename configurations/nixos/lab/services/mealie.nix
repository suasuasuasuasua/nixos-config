# mealie is a self hosted recipe manager
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "mealie";

  # default = 9000
  port = 9000;
in
{
  services.mealie = {
    inherit port;

    enable = true;
    settings = { };
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
