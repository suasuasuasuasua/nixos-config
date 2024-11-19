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
    ../../modules/desktop/kde.nix

    ## Development Tools
    # Import the default tools languages
    ../../modules/development

    ## General Apps
    ../../modules/general/proton/mail.nix
    ../../modules/general/matrix.nix
    ../../modules/general/obsidian.nix
    ../../modules/general/steam.nix

    # Design
    ../../modules/general/figma.nix

    # GPU
    ../../modules/gpu/nvidia.nix
    ../../modules/gpu/nvidia-laptop.nix

    ## Self Hosting
    ../../modules/self-host/adguardhome.nix
    ../../modules/self-host/jellyfin.nix
    ../../modules/self-host/nginx.nix
    ../../modules/self-host/ollama.nix
    ../../modules/self-host/samba.nix
    ../../modules/self-host/syncthing.nix
  ];
}
