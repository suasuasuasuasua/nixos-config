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
      # Proxy to lab's nginx over the WireGuard tunnel. Lab nginx handles
      # routing to the actual service — VPS doesn't need to know port numbers.
      proxyPass = "http://${labVpnIp}";
      proxyWebsockets = true;
      extraConfig = "client_max_body_size 0;";
    };
  };
}
