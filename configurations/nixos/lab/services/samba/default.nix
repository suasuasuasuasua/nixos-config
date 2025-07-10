# samba (smb) is a file sharing protocol
let
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/network-filesystems/samba.nix
  settings = import ./settings.nix;
in
{
  # Remember to create the samba group
  users.groups.samba = { };

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
}
