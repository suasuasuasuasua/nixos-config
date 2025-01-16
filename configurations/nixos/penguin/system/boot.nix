{
  # Use the systemd-boot EFI boot loader.
  #
  # systemd-boot seems to be the modern, preferred option when it comes down to
  # systemd-boot vs. grub.
  # boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

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
