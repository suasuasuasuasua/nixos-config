# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [
    self.nixosModules.default

    # import the modules
    (self + /modules/nixos/desktop)
    (self + /modules/nixos/development)
    (self + /modules/nixos/gpu)
    (self + /modules/nixos/gui)
    (self + /modules/nixos/services)
  ];

  # TODO: if this gets too complex/long, modularize into folders
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };

  config.nixos = {
    # desktop
    desktop = {
      kde.enable = true;
    };

    # development
    development = {
      cli.enable = true;
      nh.enable = true;
      virtualization.enable = true;
    };

    gpu = {
      nvidia.enable = true;
      nvidia.laptop = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # gui programs
    gui = {
      discord.enable = true;
      element.enable = true;
      kdenlive.enable = true;
      obsidian.enable = true;
      steam.enable = true;
      wine.enable = true;
    };

    # services
    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
      };
    };
  };

}
