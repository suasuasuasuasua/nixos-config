# https://wiki.nixos.org/wiki/Samba
# samba (smb) is a file sharing protocol
let
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/network-filesystems/samba.nix
  settings = import ./settings.nix;
in
{
  services = {
    samba = {
      inherit settings;

      enable = true;
      openFirewall = true;
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  # Remember to create the samba group
  users.groups.samba = { };
}
