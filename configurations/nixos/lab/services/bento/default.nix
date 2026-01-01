# bento pdf is a self-hosted pdf editor
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "bento";

  # default = 3000
  port = 3006;
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
