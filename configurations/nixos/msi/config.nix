# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [ self.nixosModules.default ];

  # TODO: if this gets too complex/long, modularize into folders

  # desktop
  config.nixos.desktop = {
    kde.enable = true;
  };

  config.nixos.gpu = {
    nvidia.enable = true;
    nvidia.laptop = {
      enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # development
  config.nixos.development = {
    cli.enable = true;
    nh.enable = true;
    virtualization.enable = true;
  };

  # gui programs
  config.nixos.gui = {
    discord.enable = true;
    element.enable = true;
    firefox.enable = true;
    obs.enable = true;
    obsidian.enable = true;
    steam.enable = true;
    wine.enable = true;
  };

  # services
  config.nixos.services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };

}
