# nginx on VPS acts as public reverse proxy to lab services over WireGuard tunnel
{
  config,
  infra,
  pkgs,
  ...
}:
let
  inherit (config.networking) domain;
  anubisGiteaSocket = config.services.anubis.instances.gitea.settings.BIND;
  # Route to the pi's nginx over WireGuard. Uptime-kuma binds to localhost,
  # so we must go through pi's nginx rather than directly to the port.
  # networking.hosts maps uptime-kuma.sua.dev → pi wg1IP so nginx sends
  # the correct SNI and pi's nginx picks the right vhost.
  ukBackend = "https://uptime-kuma.${domain}";
  # Status page index served from the nix store — edit the .html file directly.
  statusIndex = pkgs.writeTextDir "index.html" (
    builtins.readFile ../../pi/services/uptime-kuma-status-index.html
  );
in
{
  # Resolve uptime-kuma.sua.dev to the pi's WireGuard IP locally so nginx
  # sends the correct SNI when proxying over the tunnel to pi's nginx.
  networking.hosts."${infra.pi.wg1IP}" = [ "uptime-kuma.${domain}" ];

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
    "staging.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        index = "index.html";
        root = "/var/www/staging.sua.dev";
        tryFiles = "$uri $uri/ =404";
      };
    };
    "www.staging.${domain}" = {
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
    "uptime-kuma.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations = {
        "= /status" = {
          extraConfig = "return 301 /status/;";
        };
        # Serve a static index listing the status pages.
        # Edit services/uptime-kuma-status-index.html to update the content.
        "= /status/" = {
          root = "${statusIndex}";
          index = "index.html";
          extraConfig = "try_files /index.html =404;";
        };
        # Status pages and all their runtime dependencies are public.
        # socket.io is needed for live heartbeat data; uptime-kuma enforces
        # app-level auth on admin socket events so opening it publicly is safe.
        "~* ^/(status/|assets/|socket\\.io/|api/status-page/|icon\\.svg|favicon\\.ico)" = {
          proxyPass = ukBackend;
          proxyWebsockets = true;
        };
        # Admin UI: not served via VPS at all. Access via the Tailscale mesh
        # directly: https://uptime-kuma.pi.sua.dev (AdGuard resolves to pi LAN IP).
        # Tailscale IPs (100.64.x.x) are only used for node-to-node traffic;
        # requests to this public domain always arrive from the real client IP.
        "/" = {
          extraConfig = "return 403;";
        };
      };
    };
    "hs.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
        proxyWebsockets = true;
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
