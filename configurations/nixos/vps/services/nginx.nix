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

    streamConfig = ''
      server {
        listen 2222;
        proxy_pass 10.101.0.2:2222;
        proxy_timeout 10m;
        proxy_connect_timeout 10s;
      }
    '';
  };

  services.nginx.virtualHosts."gitea.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;

    locations."/" = {
      # Proxy to Anubis on localhost. Anubis filters bots/scrapers with a
      # proof-of-work challenge, then forwards clean traffic to lab over the
      # WireGuard tunnel. See anubis.nix for Anubis configuration.
      proxyPass = "http://127.0.0.1:8923";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 0;
      '';
    };
  };
}
