# Anubis is a bot-filtering proof-of-work challenge proxy.
# It sits between nginx and the backend, filtering out scrapers and bad actors
# before requests reach services over the WireGuard tunnel.
{
  config,
  infra,
  ...
}:
let
  inherit (config.networking) domain;
in
{
  # Map Gitea's domain to the lab's WireGuard IP so Anubis sends the correct
  # SNI when establishing the HTTPS connection to lab's nginx.
  networking.hosts."${infra.lab.wg1IP}" = [
    "gitea.${domain}"
    "mattermost.${domain}"
  ];

  services.anubis.instances."mattermost".settings = {
    TARGET = "https://mattermost.${domain}";
    BIND = "/run/anubis/anubis-mattermost/anubis.sock";
    METRICS_BIND = "/run/anubis/anubis-mattermost/anubis-metrics.sock";
    SERVE_ROBOTS_TXT = true;
    OG_PASSTHROUGH = true;
    DIFFICULTY = 5;
    WEBMASTER_EMAIL = "justinhoang@sua.dev";
  };

  services.anubis.instances."gitea".settings = {
    TARGET = "https://gitea.${domain}";
    BIND = "/run/anubis/anubis-gitea/anubis.sock";
    METRICS_BIND = "/run/anubis/anubis-gitea/anubis-metrics.sock";
    SERVE_ROBOTS_TXT = true;
    OG_PASSTHROUGH = true;
    DIFFICULTY = 5;
    WEBMASTER_EMAIL = "justinhoang@sua.dev";
  };

  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
}
