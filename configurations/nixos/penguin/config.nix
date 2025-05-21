# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{

  imports = [
    "${inputs.self}/modules/nixos"

    # # import the modules
    "${inputs.self}/modules/nixos/desktop"
    "${inputs.self}/modules/nixos/development"
    "${inputs.self}/modules/nixos/gui"
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  nixos = {
    desktop = {
      kde.enable = true;
    };

    development = {
      cli.enable = true;
      nh.enable = true;
      virtualization.enable = true;
    };

    gui = {
      obsidian.enable = true;
    };
  };
}
