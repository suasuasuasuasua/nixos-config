# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, pkgs, ... }:
{

  imports = [
    "${inputs.self}/modules/nixos"

    "${inputs.self}/modules/nixos/desktop"
    "${inputs.self}/modules/nixos/development"
  ];

  environment = {
    systemPackages = with pkgs; [
      obsidian
    ];

    variables = {
      EDITOR = "nvim";
    };
  };

  custom.nixos = {
    desktop.kde.enable = true;
    development = {
      cli.enable = true;
      nh.enable = true;
    };
  };
}
