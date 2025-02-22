# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    # disk setup
    inputs.disko.nixosModules.disko
    ./disko.nix

    # hardware setup
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    ./hardware-configuration.nix

    # config
    ./config.nix
    ./home.nix

    # system setup
    ./system
  ];
}
