# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  # You can import other NixOS modules here
  imports = [
    ## General
    ../default-configuration.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # NOTE: Fix audio and keyboard for chrultrabooks
    # ./audio.nix
    ./keyd.nix
    ./power.nix

    # Change below!
    ## Desktop environment
    ../../modules/des/gnome.nix

    ## Battery
    ../../modules/power.nix

    ## Productivity
    ../../modules/shared/productivity/proton.nix
    ../../modules/shared/productivity/app-flowy.nix
    ../../modules/shared/productivity/obsidian.nix

    ## Self Hosted
    ../../modules/shared/self-host/syncthing.nix

    ## Entertainment
    ../../modules/shared/entertainment/matrix.nix
  ];
}
