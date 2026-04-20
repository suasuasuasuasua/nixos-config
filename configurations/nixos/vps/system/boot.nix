{
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/sda";
    };

    # For VPS environments, typically want to enable Serial console
    kernelParams = [
      "console=tty1"
      "console=ttyS0"
    ];
  };
}
