# https://wiki.nixos.org/wiki/RustDesk
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "rustdesk-server";

  port = 21116;
in
{
  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
    signal.relayHosts = [ "${serviceName}.${domain}" ];
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
