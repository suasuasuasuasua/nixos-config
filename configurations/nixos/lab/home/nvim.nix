{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home.packages = [
    pkgs.vim
    inputs.nvim-config.packages.${system}.nvim
  ];
}
