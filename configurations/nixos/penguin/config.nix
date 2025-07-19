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
      appflowy
      drawio
      obsidian
    ];

    variables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    localsend = {
      enable = true;
      # default port = 53317
      # required for functionality
      openFirewall = true;
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
