{ flake, pkgs, lib, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default

    # CLI and development tools
    (self + /modules/home/cli)
    (self + /modules/home/development)
  ];

  # Allow unfree packages like VSCode
  nixpkgs.config.allowUnfree = true;

  home.username = "justinhoang";
  home.homeDirectory = lib.mkDefault "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/justinhoang";
  home.stateVersion = "24.11";
}
