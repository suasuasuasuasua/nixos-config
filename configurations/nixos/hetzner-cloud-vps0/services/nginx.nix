# nginx on VPS acts as public reverse proxy to lab services over WireGuard tunnel
{
  config,
  infra,
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
        listen ${toString infra.ports.gitea.ssh};
        proxy_pass ${infra.lab.wg1IP}:${toString infra.ports.gitea.ssh};
        proxy_timeout 10m;
        proxy_connect_timeout 10s;
      }
      server {
        listen ${toString infra.ports.minecraft-server};
        proxy_pass ${infra.lab.wg1IP}:${toString infra.ports.minecraft-server};
        proxy_timeout 10m;
        proxy_connect_timeout 10s;
      }
      server {
        listen ${toString (infra.ports.minecraft-server + 1)};
        proxy_pass ${infra.lab.wg1IP}:${toString (infra.ports.minecraft-server + 1)};
        proxy_timeout 10m;
        proxy_connect_timeout 10s;
      }
    '';
  };

  services.nginx.virtualHosts = {
    ${domain} = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      locations."/" = {
        index = "index.html";
        root = "/var/www/sua.dev";
        tryFiles = "$uri $uri/ =404";
      };
    };
    "www.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      globalRedirect = domain;
    };
    "files.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      locations."/" = {
        root = "/var/www/files";
        extraConfig = ''
          autoindex on;
          autoindex_exact_size off;
          autoindex_localtime on;
          limit_rate 10m;  # cap per-connection download speed
        '';
      };
    };
    "gitea.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      locations."/" = {
        # Proxy to Anubis on localhost. Anubis filters bots/scrapers with a
        # proof-of-work challenge, then forwards clean traffic to lab over the
        # WireGuard tunnel. See anubis.nix for Anubis configuration.
        proxyPass = "http://unix:${anubisGiteaSocket}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
        '';
      };
    };
  };

  users.users.admin.extraGroups = [ "nginx" ];
}
