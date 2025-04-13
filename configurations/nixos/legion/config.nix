# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{
  imports = [
    "${inputs.self}/module/nixos"

    # import the modules
    "${inputs.self}/module/nixos/desktop"
    "${inputs.self}/module/nixos/development"
    "${inputs.self}/module/nixos/gpu"
    "${inputs.self}/module/nixos/gui"
    "${inputs.self}/module/nixos/services"
  ];

  # TODO: if this gets too complex/long, modularize into folders
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };

  # desktop
  config.nixos = {
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
    };

    # gui programs
    gui = {
      discord.enable = true;
      element.enable = true;
      gimp.enable = true;
      kdenlive.enable = true;
      lutris.enable = true;
      obsidian.enable = true;
      steam.enable = true;
      wine.enable = true;
    };

    services = {
      ollama = {
        enable = true;
        acceleration = "cuda";
      };
      open-webui.enable = true;
      openrgb = {
        enable = true;
        motherboard = "intel";
      };
    };
  };
}
