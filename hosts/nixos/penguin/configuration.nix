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

    # NOTE: Fix audio and keyboard for chrultrabooks
    # ./audio.nix
    ./keyd.nix
    ./power.nix

    # Change below!
    ## Desktop environment
    # TODO: figure out a better way to choose profiles
    ../../../modules/nixos/des/gnome.nix
    # ../../../modules/nixos/des/sway.nix

    ## Battery
    ../../../modules/nixos/power.nix

    ## Self Hosted
    ../../../modules/shared/self-host/syncthing.nix

    ## Entertainment
    ../../../modules/shared/entertainment/matrix.nix
  ];
}
