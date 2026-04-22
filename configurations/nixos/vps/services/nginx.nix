# nginx on VPS acts as public reverse proxy to lab services over WireGuard tunnel
{
  config,
  ...
}:
let
  inherit (config.networking) domain;
  anubisGiteaSocket = config.services.anubis.instances.gitea.settings.BIND;
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
      # Proxy to Anubis over a local unix socket. Anubis then proxies to lab
      # nginx over the WireGuard tunnel and filters bad actors/bots.
      proxyPass = "http://unix:${anubisGiteaSocket}";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 0;
      '';
    };
  };
}
