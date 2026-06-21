{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home.packages = [ inputs.nvim-config.packages.${system}.nvim ];
}
