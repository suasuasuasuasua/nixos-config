{
  imports = [
    ./adguardhome
    ./isponsorblocktv

    ./acme.nix
    ./avahi.nix

    ./glances.nix
    ./nginx.nix
    ./prometheus-node-exporter.nix
    ./tailscale.nix
    ./uptime-kuma.nix
    ./wireguard.nix
  ];
}
