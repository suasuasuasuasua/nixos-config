# nginx on VPS acts as public reverse proxy to lab services over WireGuard tunnel
{
  config,
  ...
}:
let
  inherit (config.networking) domain;
  labVpnIp = "10.101.0.2";
in
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  services.nginx.virtualHosts."gitea.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;

    locations."/" = {
      proxyPass = "http://${labVpnIp}:3001";
      proxyWebsockets = true;
      extraConfig = "client_max_body_size 0;";
    };
  };
}
