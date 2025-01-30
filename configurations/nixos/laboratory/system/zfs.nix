{ config, ... }:
{
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  # Ensure that the kernel is compatible with zfs
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
}
