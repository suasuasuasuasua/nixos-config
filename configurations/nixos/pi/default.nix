# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
in
{
  imports = [
    # pi setup
    inputs.rpi-nix.nixosModules.sd-image
    inputs.rpi-nix.nixosModules.raspberry-pi

    # hardware
    ./hardware-configuration.nix

    # config
    ./config.nix
    ./home.nix

    # system setup
    ./system

    # services setup
    ./services
  ];
}
