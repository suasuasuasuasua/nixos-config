{pkgs, ...}: {
  programs.tmux = {
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

    # shell = "\${pkgs.zsh}/bin/zsh";
    # shell = "zsh";
    shell = "/Users/justin/.nix-profile/bin/zsh";
    mouse = true;

    prefix = "C-space";
    keyMode = "vi";

    baseIndex = 1;

    # extraConfig = ''
    #   set-option -sa terminal-overrides ",xterm*:Tc"
    #
    #   bind '"' split-window -c "#{pane_current_path}"
    #
    #   # restore the pane contents for neovim
    #   set -g @continuum-restore 'on'
    #   set -g @resurrect-capture-pane-contents 'on'
    #   set -g @resurrect-strategy-nvim 'session'
    #
    #   bind-key -T copy-mode-vi v send-keys -X begin-selection
    #   bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
    #   bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    # '';
  };
}
