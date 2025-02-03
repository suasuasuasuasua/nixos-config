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

    # Port 61208
    (self + /modules/nixos/services/glances.nix)
  ];
}
