# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{

  imports = [
    "${inputs.self}/modules/nixos"

    # # import the modules
    "${inputs.self}/modules/nixos/services"
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  # development
  nixos.development = {
    cli.enable = true;
    nh.enable = true;
    virtualization.enable = true;
  };
}
