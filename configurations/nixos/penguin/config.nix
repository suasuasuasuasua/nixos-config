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
  };
}
