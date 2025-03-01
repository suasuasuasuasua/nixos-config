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

    # import modules
    (self + /modules/darwin/development)
    (self + /modules/darwin/gui)
    (self + /modules/darwin/utility)
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

      gui = {
        discord.enable = true; # voice and text chat software
        element.enable = true; # matrix platform client
        firefox.enable = true; # web browser
        kdenlive.enable = true; # linear video editor
        obs.enable = true; # studio recorder
        obsidian.enable = true; # markdown based note-taking app
      };

      utility = {
        appcleaner.enable = true; # cleans log/config files
        iina.enable = true; # media player
      };
    };
  };
}
