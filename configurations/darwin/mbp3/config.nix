# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/modules/darwin"
    "${inputs.self}/modules/darwin/development"

    inputs.mac-app-util.darwinModules.default
  ];

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      appcleaner
      betterdisplay
      appflowy
      discord
      feishin
      iina
      iterm2
      obsidian
      utm
    ];
  };

  custom.darwin = {
    development.cli = true;
  };
}
