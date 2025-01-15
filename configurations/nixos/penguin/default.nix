# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = ([
    ./hardware-configuration.nix

    # Desktop environment
    (self + /modules/nixos/desktop)

    # Development
    (self + /modules/nixos/development)

    # # GUI Apps
    # Notes
    (self + /modules/nixos/gui/obsidian.nix)
    # Chat
    (self + /modules/nixos/gui/matrix.nix)
  ]
  ++
  # A module that automatically imports everything else in the parent folder.
  (
    let prefix = ./system; in
    with builtins;
    map
      (fn: "${prefix}/${fn}")
      (filter (fn: fn != "default.nix") (attrNames
        (readDir "${prefix}")))
  ))
  ;

  # Allow unfree packages like VSCode
  nixpkgs.config.allowUnfree = true;

  # TODO: figure out a dynamic way to allocate this (not that there any other
  # users...just helps my brain avoid hardcode)
  # Enable home-manager for "justinhoang" user
  home-manager.users."justinhoang" = {
    imports = [ (self + /configurations/home/justinhoang.nix) ];
  };
}
