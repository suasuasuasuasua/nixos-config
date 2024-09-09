# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
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
    username = "justin";
    homeDirectory = "/home/justin";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    thunderbird
    firefox
    spotify
    discord

    filelight
    timeshift
    yazi
    fastfetch
    btop
    imv
    mpv
    zathura
    vscode
  ];

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = "j124.dev@gmail.com";
      userName = "Justin Hoang";
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
        theme = "frisk";
      };
      plugins = with pkgs; [
        {
          name = "vi-mode";
          src = zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };
    neovim = {
      enable = true;
      package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        continuum
        yank
        fpp
        vim-tmux-navigator
        catppuccin
      ];
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on
        set -g prefix C-Space
        unbind C-b
        bind C-Space send-prefix
        bind '"' split-window -c "#{pane_current_path}"
        set -g @catppuccin_flavour 'mocha'
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on
        setw -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
    };
    alacritty = {
      enable = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
