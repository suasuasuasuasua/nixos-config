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
    ../../default-configuration.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Change below!
    ## Desktop environment
    ../../../modules/nixos/des/gnome.nix

    ## Self Hosted
    ../../../modules/shared/self-host/syncthing.nix
  ];
}
