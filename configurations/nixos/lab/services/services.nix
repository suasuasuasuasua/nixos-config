{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports =
    # General
    [
      (self + /modules/nixos/services/dashy.nix)
      (self + /modules/nixos/services/nginx.nix)
    ]
    # Networking
    ++ [
      (self + /modules/nixos/services/adguardhome.nix)
    ]
    # Productivity
    ++ [
      (self + /modules/nixos/services/actual.nix)
      (self + /modules/nixos/services/mealie.nix)
      (self + /modules/nixos/services/paperless.nix)
    ]
    # Media
    ++ [
      (self + /modules/nixos/services/audiobookshelf.nix)
      (self + /modules/nixos/services/calibre.nix)
      (self + /modules/nixos/services/jellyfin.nix)
      (self + /modules/nixos/services/jellyseerr.nix)
      (self + /modules/nixos/services/navidrome.nix)
    ]
    # System monitoring
    ++ [
      (self + /modules/nixos/services/glances.nix)
    ]
    # File sharing
    ++ [
      # Share files via git web interface
      (self + /modules/nixos/services/wastebin.nix)
      # Share files via git web interface
      (self + /modules/nixos/services/gitweb.nix)
      # Share files via SMB
      (self + /modules/nixos/services/samba.nix)
    ];
}
