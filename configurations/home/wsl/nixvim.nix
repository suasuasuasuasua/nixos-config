{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
inputs.nixvim-config.packages.${system}.default
