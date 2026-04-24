# 13ft bypasses paywalls
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "13ft";
in
{
  imports = [ ./compose.nix ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports."13ft"}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
