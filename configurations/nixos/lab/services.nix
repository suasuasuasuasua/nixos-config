{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports =
    # Networking
    [
      (self + /modules/nixos/services/nginx.nix)
      # Port 3000
      (self + /modules/nixos/services/adguardhome.nix)
      # Port ???
      (self + /modules/nixos/services/dashy.nix)
    ]
    # Productivity
    ++ [
      # Port 3001
      (self + /modules/nixos/services/actual.nix)
      # Port 9000
      (self + /modules/nixos/services/mealie.nix)
    ]
    # Media
    ++ [
      # Port 8096
      (self + /modules/nixos/services/jellyfin.nix)
    ]
    # System monitoring
    ++ [
      # Port 61208
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
