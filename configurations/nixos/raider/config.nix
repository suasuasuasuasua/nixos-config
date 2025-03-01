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

    gpu = {
      nvidia.enable = true;
      nvidia.laptop = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # development
    development = {
      cli.enable = true;
      nh.enable = true;
      virtualization.enable = true;
    };

    # gui programs
    gui = {
      discord.enable = true;
      element.enable = true;
      firefox.enable = true;
      kdenlive.enable = true;
      obs.enable = true;
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
