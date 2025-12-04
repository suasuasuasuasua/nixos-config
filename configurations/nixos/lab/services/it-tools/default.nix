# it-tools is a collection of handy online tools for developers
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "it-tools";

  # default = 8080
  port = 8085;
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
