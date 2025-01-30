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
    # Port 8096
    (self + /modules/nixos/services/jellyfin.nix)

    (self + /modules/nixos/services/samba.nix)
  ];
}
