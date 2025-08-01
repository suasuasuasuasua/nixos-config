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
      appflowy
      betterdisplay
      # bitwarden-cli # TODO: broken on darwin
      bitwarden-desktop
      discord
      feishin
      hidden-bar
      iina
      iterm2
      obsidian
      shottr
      utm
    ];
  };

  custom.darwin = {
    development.cli.enable = true;
  };
}
