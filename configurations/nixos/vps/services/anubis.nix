{
  config,
  ...
}:
let
  labVpnIp = "10.101.0.2";
in
{
  services.anubis.instances.gitea.settings = {
    TARGET = "https://${labVpnIp}";
    BIND = "/run/anubis/anubis-gitea/anubis.sock";
    METRICS_BIND = "/run/anubis/anubis-gitea/anubis-metrics.sock";
    SERVE_ROBOTS_TXT = true;
    OG_PASSTHROUGH = true;
  };

  users.users.nginx.extraGroups = [ config.users.groups.anubis.name ];
}
