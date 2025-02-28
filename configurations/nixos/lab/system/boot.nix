{ pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  #
  # systemd-boot seems to be the modern, preferred option when it comes down to
  # systemd-boot vs. grub.
  # boot.initrd.systemd.enable = true;
  boot = {
    loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };

    loader.efi.canTouchEfiVariables = true;

    # 6.12 faster than 6.6 (https://www.phoronix.com/review/linux-66-612-lts)
    # current LTS on 24.11 if 6.6, so we can go back later in May 25
    kernelPackages = pkgs.linuxPackages_6_12;
  };

  # Alternative that I'll keep around. Basically, the problem was the
  # boot.loader.grub.device was being set to an incorrect value when I was
  # following the NixOS ZFS guide (lol). I just needed to set it to "nodev"
  #
  # boot.loader.grub = {
  #   enable = true;
  #   zfsSupport = true;
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  #   device = "nodev";
  # };
}
