{
  lib,
  config,
  ...
}:
let
  cfg = config.nixos.gpu.nvidia;
in
{
  options.nixos.gpu.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia GPU drivers";
    laptop = {
      enable = lib.mkEnableOption "Enable Nvidia GPU drivers for laptops";
      intelBusId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          the bus id for the intel gpu (integrated or discrete)
        '';
      };
      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          the bus id for the nvidia gpu (discrete)
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware = {
      graphics.enable = true;
      nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        powerManagement = {
          # Nvidia power management. Experimental, and can cause sleep/suspend
          # to fail. Enable this if you have graphical corruption issues or
          # application crashes after waking up from sleep. This fixes it by
          # saving the entire VRAM memory to /tmp/ instead of just the bare
          # essentials.
          enable = true;

          # Fine-grained power management. Turns off GPU when not in use.
          # Experimental and only works on modern Nvidia GPUs (Turing or newer).
          finegrained = false;
        };

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = true;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # 1. sudo lshw -c display
        # 2. Under 'bus info', translate the bus ID hexadecimal to decimal and format:
        #    pci@0000:0e:00.0 -> PCI:14:0:0
        #    - Do this step for both the Nvidia/AMD and integrated GPU
        prime = lib.mkIf cfg.laptop.enable {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          # Make sure to use the correct Bus ID values for your system!
          inherit (cfg.laptop) intelBusId;
          inherit (cfg.laptop) nvidiaBusId;
        };
      };

    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
