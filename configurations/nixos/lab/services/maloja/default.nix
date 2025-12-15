# maloja is a self hosted scrobbler
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "maloja";

  # default = 42010
  port = 42010;
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
