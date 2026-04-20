{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # For VPS environments, typically want to enable Serial console
    kernelParams = [
      "console=tty1"
      "console=ttyS0"
    ];
  };
}
