{
  imports = [
    ./dashy
    # ./wireguard # TODO: implement wireguard connection to lab

    ./acme.nix
    ./authelia.nix
    ./avahi.nix
    ./fail2ban.nix
    ./glances.nix
    ./nginx.nix
    ./smart.nix
    ./uptime-kuma.nix
  ];
}
