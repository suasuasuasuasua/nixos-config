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
    # Productivity
    ++ [
      (self + /modules/nixos/services/actual.nix)
      (self + /modules/nixos/services/mealie.nix)
    ]
    # Media
    ++ [
      (self + /modules/nixos/services/navidrome.nix)
      (self + /modules/nixos/services/jellyfin.nix)
    ]
    # System monitoring
    ++ [
      (self + /modules/nixos/services/glances.nix)
    ]
    # File sharing
    ++ [
      # Share files via SMB
      (self + /modules/nixos/services/samba.nix)
      # Share files via git web interface
      (self + /modules/nixos/services/gitweb.nix)
    ];
}
