# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [ self.darwinModules.default ];

  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };
}
