# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  # You can import other NixOS modules here
  imports = [
    ## General
    ../default-configuration.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Change below!

    ## Desktop environment
    ../../modules/desktop/gnome.nix

    ## Development Tools
    # Import the default tools languages
    ../../modules/development

    ## General Apps
    ../../modules/general/proton/mail.nix
    ../../modules/general/matrix.nix
    ../../modules/general/obsidian.nix

    # Design
    ../../modules/general/figma.nix

    # Games
    ../../modules/general/steam.nix
    ../../modules/general/wine.nix

    ## Self Hosting
    ../../modules/self-host/syncthing.nix
  ];
}
