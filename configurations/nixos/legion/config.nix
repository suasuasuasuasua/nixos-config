# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/modules/nixos"

    "${inputs.self}/modules/nixos/desktop"
    "${inputs.self}/modules/nixos/development"

    "${inputs.self}/modules/nixos/steam.nix"
  ];

  environment = {
    systemPackages = with pkgs; [
      bitwarden-cli
      bitwarden-desktop
      element-desktop
      discord
      feishin
      gimp
      kdePackages.kdenlive
      obsidian
      picard
      protonmail-desktop
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
    steam.enable = true;
  };
}
