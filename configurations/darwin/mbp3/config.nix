# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{
  imports = [
    # import modules
    "${inputs.self}/modules/darwin"

    "${inputs.self}/modules/darwin/development"
    "${inputs.self}/modules/darwin/gui"
    "${inputs.self}/modules/darwin/utility"

    # instead of (self + /modules/nixos/gui), use workaround for "X" config or
    # service does not exist. quirky cause darwin doesn't have everything that
    # nixos does
    "${inputs.self}/modules/nixos/gui/appflowy.nix"
    "${inputs.self}/modules/nixos/gui/discord.nix"
    "${inputs.self}/modules/nixos/gui/obsidian.nix"
    "${inputs.self}/modules/nixos/gui/protonmail.nix"

    inputs.mac-app-util.darwinModules.default
  ];

  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };

  config = {
    # shared cross platform apps
    darwin = {
      development = {
        cli.enable = true; # useful cli tools
        iterm2.enable = true; # terminal emulator
        utm.enable = true; # virtual machine manager
      };

      utility = {
        appcleaner.enable = true; # cleans log/config files
        iina.enable = true; # media player
      };
    };

    nixos = {
      gui = {
        appflowy.enable = true; # open source notion
        discord.enable = true; # voice and text chat software
        obsidian.enable = true; # markdown based note-taking app
        protonmail.enable = true; # protonmail client
      };
    };
  };
}
