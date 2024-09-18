# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  user,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    ../shared

    ./packages.nix

    # Essentials
    ./programs/alacritty.nix
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/firefox.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/neovim/neovim.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/zsh.nix

    # Desktop environment
    ./config/gnome.nix

    # Themes
    ./config/theme.nix
  ];
}
