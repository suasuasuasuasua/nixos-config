# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/modules/darwin"
    "${inputs.self}/modules/darwin/development"
  ];

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      # appcleaner
      # bitwarden-cli # TODO: broken on darwin
      # iterm2 # NOTE: native terminal app is pretty good now
      appflowy
      betterdisplay
      bitwarden-desktop
      discord
      feishin
      hidden-bar
      iina
      jetbrains.clion
      jetbrains.pycharm-community
      obsidian
      shottr
      utm
    ];
  };

  custom.darwin = {
    development.cli.enable = true;
  };
}
