{
  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    # TODO: according to https://github.com/nix-community/disko/blob/master/docs/quickstart.md#step-7-complete-the-nixos-installation,
    #       we don't need to have the this set?
    #
    #       or according to https://search.nixos.org/options?channel=24.11&show=boot.loader.grub.mirroredBoots&from=0&size=50&sort=relevance&type=packages&query=grub.mirr,
    #       we need to set the device to the actual name?
    # mirroredBoots = [
    #  { devices = [ "nodev" ]; path = "/boot"; }
    # ];
  };

  # Automatically import zpools
  # boot.zfs.extraPools = [ "zpool_name" ];
}
