# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{

  imports = [
    "${inputs.self}/modules/nixos"
    "${inputs.self}/modules/nixos/development"
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  custom.nixos.development = {
    cli.enable = true;
    nh.enable = true;
  };
}
