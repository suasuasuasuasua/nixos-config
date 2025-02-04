{
  # https://github.com/nix-community/raspberry-pi-nix/blob/master/overlays/default.nix

  # https://github.com/nix-community/raspberry-pi-nix/blob/master/rpi/default.nix
  raspberry-pi-nix = {
    board = "bcm2711";
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
