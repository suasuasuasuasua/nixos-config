{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports =
    # General
    [
      (self + /modules/nixos/services/nginx.nix)
      (self + /modules/nixos/services/dashy.nix)
    ]
    # Networking
    ++ [
      (self + /modules/nixos/services/adguardhome.nix)
    ]
    ++ [
      (self + /modules/nixos/services/glances.nix)
    ];
}
