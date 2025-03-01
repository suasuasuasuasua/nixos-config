# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [
    self.darwinModules.default
    self.nixosModules.default
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
        iterm2.enable = true; # terminal emulator
        utm.enable = true; # virtual machine manager
      };
      utility = {
        appcleaner.enable = true; # (cleans log/config files too)
        iina.enable = true; # media player
      };
    };

    # modules available through home manager (preferred when possible)
    home = {
      development = {
        visual-studio-code.enable = true; # text editor
      };
      gui = {
        spotify.enable = true; # music platform
      };
    };

    # shared cross plataform configs
    nixos = {
      # general
      gui = {
        discord.enable = true; # voice and text chat software
        element.enable = true; # matrix platform client
        firefox.enable = true; # web browser
        kdenlive.enable = true; # linear video editor
        obs.enable = true; # studio recorder
        obsidian.enable = true; # markdown based note-taking app
        steam.enable = true; # video game platform (x)
      };
      services = {
        ollama.enable = true; # llm manager
      };
    };
  };
}
