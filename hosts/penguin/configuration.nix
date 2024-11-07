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
    ../../modules/desktop/kde.nix

    ## Development Tools
    # Import the default tools languages
    ../../modules/development

    ## General Apps
    ../../modules/general/matrix.nix
    ../../modules/general/obsidian.nix
    ../../modules/general/proton/mail.nix

    # Design
    ../../modules/general/figma.nix
    ../../modules/general/obs.nix
    ../../modules/general/gimp.nix
    ../../modules/general/shotcut.nix

    ## Self Hosting
    ../../modules/self-host/syncthing.nix
  ];
}
