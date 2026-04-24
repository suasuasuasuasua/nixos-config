# Anubis is a bot-filtering proof-of-work challenge proxy.
# It sits between nginx and the lab backend, filtering out scrapers and bad actors
# before requests reach Gitea over the WireGuard tunnel.
{
  config,
  infra,
  ...
}:
let
  inherit (config.networking) domain;
in
{
  # Map the Gitea domain to the lab's WireGuard IP locally so Anubis sends
  # the correct SNI when establishing the HTTPS connection to lab's nginx.
  networking.hosts."${infra.lab.wg1Ip}" = [ "gitea.${domain}" ];

  services.anubis.instances."gitea" = {
    settings = {
      TARGET = "https://gitea.${domain}";
      BIND = "/run/anubis/anubis-gitea/anubis.sock";
      METRICS_BIND = "/run/anubis/anubis-gitea/anubis-metrics.sock";
      SERVE_ROBOTS_TXT = true;
      OG_PASSTHROUGH = true;
      DIFFICULTY = 5;
      WEBMASTER_EMAIL = "justinhoang@sua.dev";
    };
  };

  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
}
