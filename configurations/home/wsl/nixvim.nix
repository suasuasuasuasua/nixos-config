{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
inputs.nixvim-config.packages.${system}.default.extend {
  config.nixvim.plugins.custom = {
    auto-dark-mode.enable = false;
    img-clip.enable = false;
    markdown-preview.enable = false;
    obsidian.enable = false;
    remote-nvim.enable = false;
  };
}
