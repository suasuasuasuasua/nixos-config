# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [ self.nixosModules.default ];

  # TODO: if this gets too complex/long, modularize into folders
}
