# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{
  imports = [
    "${inputs.self}/modules/nixos"

    # import the modules
    "${inputs.self}/modules/nixos/desktop"
    "${inputs.self}/modules/nixos/gpu"
    "${inputs.self}/modules/nixos/gui"
    "${inputs.self}/modules/nixos/services"
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  # desktop
  nixos = {
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
