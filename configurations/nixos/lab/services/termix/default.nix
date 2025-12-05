# termix is a web based terminal ssh manager
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "termix";

  # default = 8080
  port = 8086;
in
{
  imports = [ ./compose.nix ];

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
