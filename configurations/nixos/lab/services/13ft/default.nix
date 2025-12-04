# 13ft bypasses paywalls
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "13ft";

  # default = 5000
  port = 5001;
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
