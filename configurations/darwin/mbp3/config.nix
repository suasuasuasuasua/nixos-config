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
        element.enable = false; # element signin link is broken?
        obsidian.enable = true; # markdown based note-taking app
        rpi-imager.enable = false; # broken on version 1.8.5 and  channel 24.11
      };

      utility = {
        appcleaner.enable = true; # cleans log/config files
        iina.enable = true; # media player
      };
    };
  };
}
