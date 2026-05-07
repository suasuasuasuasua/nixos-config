# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ pkgs, inputs, ... }:
{

  imports = [
    inputs.self.nixosModules.base
    inputs.self.nixosModules.development
  ];

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = [
    pkgs.claude-code
  ];

  custom.nixos.development = {
    cli.enable = true;
    nh.enable = true;
  };
}
