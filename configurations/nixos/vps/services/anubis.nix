# Anubis is a bot-filtering proof-of-work challenge proxy.
# It sits between nginx and the lab backend, filtering out scrapers and bad actors
# before requests reach Gitea over the WireGuard tunnel.
{
  config,
  ...
}:
let
  inherit (config.networking) domain;
  labVpnIp = "10.101.0.2";
in
{
  # Map the Gitea domain to the lab's WireGuard IP locally so Anubis sends
  # the correct SNI when establishing the HTTPS connection to lab's nginx.
  networking.hosts."${labVpnIp}" = [ "gitea.${domain}" ];

  services.anubis.instances."gitea" = {
    settings = {
      TARGET = "https://gitea.${domain}";
      BIND = "127.0.0.1:8923";
      DIFFICULTY = 5;
      SERVE_ROBOTS_TXT = true;
    };
  };
}
