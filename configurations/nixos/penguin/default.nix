# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
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

    # system setup
    ./system

    # Default
    self.nixosModules.default
  ];

  # desktop
  config.desktop.kde.enable = true;

  # development
  config.development = {
    cli.enable = true;
    nh.enable = true;
    virtualization.enable = true;
  };

  # gui programs
  config.gui = {
    discord.enable = true;
    element.enable = true;
    firefox.enable = true;
    obs.enable = true;
    obsidian.enable = true;
    steam.enable = true;
    wine.enable = true;
  };
}
