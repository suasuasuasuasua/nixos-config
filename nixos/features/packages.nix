{
  config,
  pkgs,
  lib,
  ...
}: {
  fonts.packages = with pkgs; [(nerdfonts.override {fonts = ["JetBrainsMono"];})];

  environment.systemPackages = with pkgs; [
    inputs.home-manager.packages.${pkgs.system}.default
    git
    zip
    unzip
    wget
    curl
    tree-sitter
    ripgrep
    fd
    gnumake
    gcc
    lua
    luarocks
    go
    python3
    nodejs
    rustup
    nixfmt-rfc-style
  ];
}