{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    (self + /modules/nixos/services/nginx.nix)

    # Port 3000
    (self + /modules/nixos/services/adguardhome.nix)
    # Port 3001
    (self + /modules/nixos/services/actual.nix)
    # TODO: migrate to homepage-dashboard?
    # Port 8080
    (self + /modules/nixos/services/dashy.nix)
    # Port 8096
    (self + /modules/nixos/services/jellyfin.nix)
    # Port 9000
    (self + /modules/nixos/services/mealie.nix)
    # Port 9090
    (self + /modules/nixos/services/cockpit.nix)

    (self + /modules/nixos/services/samba.nix)
  ];
}
