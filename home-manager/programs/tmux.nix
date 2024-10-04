{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
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

      set -g @continuum-restore 'on'
      # restore the pane contents
      set -g @resurrect-capture-pane-contents 'on'
      # for neovim
      set -g @resurrect-strategy-nvim 'session'

      resurrect_dir="$HOME/.tmux/resurrect"
      set -g @resurrect-dir $resurrect_dir
      set -g @resurrect-hook-post-save-all "sed -i 's/--cmd lua.*--cmd set packpath/--cmd \"lua/g; s/--cmd set rtp.*\$/\"/' $resurrect_dir/last"
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-processes '"~nvim"'

      setw -g mode-keys vi

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';
  };
}
