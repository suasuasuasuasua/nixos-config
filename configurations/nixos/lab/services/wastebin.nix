{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "wastebin";

  # default = 8088
  port = 8088;
in
{
  services.wastebin = {
    enable = true;
    settings = {
      WASTEBIN_ADDRESS_PORT = "0.0.0.0:${toString port}";
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
