# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;

  # Define a function to import all .nix files except default.nix from a given prefix
  importFolder =
    prefix:
    with builtins;
    let
      # Read the directory and filter out non-.nix files and default.nix
      nixFiles = filter (fn: fn != "default.nix" && builtins.match "^.*\\.nix$" fn != null) (
        attrNames (readDir "${prefix}")
      );

      # Create a list of file paths to return
      nixPaths = map (name: "${prefix}/${name}") nixFiles;
    in
    nixPaths;
in
{
  imports = (
    [
      # disk setup
      inputs.disko.nixosModules.disko
      ./disko.nix

      # hardware setup
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./hardware-configuration.nix

      # Default
      self.nixosModules.default
    ]
    ++ importFolder ./services
    ++ importFolder ./system
  );

  # Allow unfree packages like VSCode
  nixpkgs.config.allowUnfree = true;

  # TODO: figure out a dynamic way to allocate this (not that there any other
  # users...just helps my brain avoid hardcode)
  # Enable home-manager for "justinhoang" user
  home-manager.users."justinhoang" = {
    imports = [ (self + /configurations/home/justinhoang.nix) ];
  };
}
