# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [
    inputs.mac-app-util.darwinModules.default

    self.darwinModules.default

    # import modules
    (self + /modules/darwin/development)
    (self + /modules/darwin/gui)
    (self + /modules/darwin/utility)

    # instead of (self + /modules/nixos/gui), use workaround for "X" config or
    # service does not exist. quirky cause darwin doesn't have everything that
    # nixos does
    (self + /modules/nixos/gui/appflowy.nix)
    (self + /modules/nixos/gui/discord.nix)
    (self + /modules/nixos/gui/obsidian.nix)
  ];

  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };

  config = {
    # shared cross plataform apps
    darwin = {
      development = {
        cli.enable = true; # useful cli tools
        iterm2.enable = true; # terminal emulator
        utm.enable = true; # virtual machine manager
      };

      gui = {
        rpi-imager.enable = false; # broken on version 1.8.5 and  channel 24.11
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
      };
    };
  };
}
