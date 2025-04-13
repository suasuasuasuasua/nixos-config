# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{

  imports = [
    "${inputs.self}/modules/nixos"

    # # import the modules
    "${inputs.self}/modules/nixos/development"
    "${inputs.self}/modules/nixos/services"
  ];

  # TODO: if this gets too complex/long, modularize into folders
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };

  # development
  config.nixos.development = {
    cli.enable = true;
    nh.enable = true;
    virtualization.enable = true;
  };
}
