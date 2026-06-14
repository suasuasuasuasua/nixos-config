{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  nixvim = inputs.nixvim-config.packages.${system}.default;
in
{
  home.packages = [ nixvim ];
}
