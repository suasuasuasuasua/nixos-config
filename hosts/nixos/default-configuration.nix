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
    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../../modules/shared

    ### General System Configuration
    ../../modules/nixos/boot.nix
    ../../modules/nixos/general.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/productivity.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/virtualization.nix

    ## System Packages
    ../../modules/nixos/packages.nix
  ];
}
