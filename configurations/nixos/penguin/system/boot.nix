{
  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev" ]; path = "/boot"; }
    ];
  };

  # Automatically import zpools
  # boot.zfs.extraPools = [ "zpool_name" ];
}
