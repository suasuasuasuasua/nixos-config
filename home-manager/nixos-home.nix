# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example
    ./theme.nix
    ./users.nix

    # Desktop Configurations
    ./desktop/gnome.nix

    # CLI apps
    ./cli/bat.nix
    ./cli/devenv.nix
    ./cli/direnv.nix
    ./cli/fzf.nix
    ./cli/git.nix
    ./cli/tmux.nix

    # Development - text editors, ides, etc.
    ./development/neovim/neovim.nix
    ./development/github-desktop.nix
    ./development/vscode.nix

    # General Apps
    ./general/discord.nix
    ./general/firefox.nix
    ./general/spotify.nix
    ./general/thunderbird.nix

    # Shell
    ./shell/zsh.nix

    # Terminal
    ./terminal/alacritty.nix
  ];

  programs.home-manager.enable = true;

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
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
