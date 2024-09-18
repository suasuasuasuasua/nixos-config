# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ## General
    ../default-configuration.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Change below!
    ## Desktop environment
    ../../../modules/nixos/des/gnome.nix

    ## Battery
    ../../../modules/nixos/power.nix

    ## GPU options
    ../../../modules/nixos/gpu/nvidia.nix
    # If you are running laptop!
    ../../../modules/nixos/gpu/nvidia-laptop.nix

    ## Self Hosted
    ../../../modules/shared/self-host/ollama.nix
    ../../../modules/shared/self-host/syncthing.nix

    ## Games
    ../../../modules/shared/entertainment/steam.nix
  ];
}
