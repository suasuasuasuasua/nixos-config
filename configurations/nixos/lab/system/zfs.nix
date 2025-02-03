{ pkgs, ... }:
{
  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  # Ensure that the kernel is compatible with zfs
  boot.kernelPackages = pkgs.linuxPackages_6_6; # update to LTS as we go
}
