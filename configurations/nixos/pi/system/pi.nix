{
  # https://github.com/nix-community/raspberry-pi-nix/blob/master/overlays/default.nix

  # https://github.com/nix-community/raspberry-pi-nix/blob/master/rpi/default.nix
  raspberry-pi-nix = {
    board = "bcm2711";
    # refer to flake.lock for rpi-linux version
    # - workaround until https://github.com/nix-community/raspberry-pi-nix/issues/116
    # kernel-version = "v6_6_67"; # 6.6 LTS
    kernel-version = "v6_12_11"; # 6.12 LTS
    # TODO: why isn't this cached? faster build if i disable
    # i don't have cameras anyway
    libcamera-overlay = {
      enable = false;
    };
  };
  # https://github.com/nix-community/raspberry-pi-nix/blob/master/rpi/config.nix
  hardware = {
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            BOOT_UART = {
              value = 1;
              enable = true;
            };
            uart_2ndstage = {
              value = 1;
              enable = true;
            };
          };
          dt-overlays = {
            disable-bt = {
              enable = true;
              params = { };
            };
          };
        };
      };
    };
  };
}
