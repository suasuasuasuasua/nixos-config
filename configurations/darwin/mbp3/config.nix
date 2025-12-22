# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{
  imports = [
    "${inputs.self}/modules/darwin"
    "${inputs.self}/modules/darwin/development"
  ];

  environment.variables.EDITOR = "nvim";

  custom.darwin.development.cli.enable = true;
}
