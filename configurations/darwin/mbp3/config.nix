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
        discord.enable = true; # voice and text chat software
        element.enable = true; # matrix platform client
        obsidian.enable = true; # markdown based note-taking app
      };

      utility = {
        appcleaner.enable = true; # cleans log/config files
        iina.enable = true; # media player
      };
    };
  };
}
