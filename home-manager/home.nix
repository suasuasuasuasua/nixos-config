# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  user,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    ./packages.nix

    # Programs
    ./programs/alacritty.nix
    ./programs/direnv.nix
    ./programs/firefox.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/neovim/neovim.nix
    ./programs/tmux.nix
    ./programs/vscode.nix
    ./programs/zsh.nix

    # Themes
    ./themes/global.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "${user.name}";
    homeDirectory = "${user.home}";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
