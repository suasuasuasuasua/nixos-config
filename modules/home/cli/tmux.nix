{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.cli.tmux;
in
{
  options.home.cli.tmux = {
    enable = lib.mkEnableOption ''
      Terminal multiplexer
    '';
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        continuum # continuous saving and start of tmux
        fpp # find and open files in the current buffer
        resurrect # save sessions past system restarts
        sensible # sensible config
        tmux-powerline # pretty powerline
        vim-tmux-navigator # prettier statusline
        yank # better copy and paste functionality
      ];

      sensibleOnTop = true;
      mouse = true;
      prefix = "C-Space";
      keyMode = "vi";
      baseIndex = 1;

      extraConfig =
        # tmux
        ''
          set-option -sa terminal-overrides ",xterm*:Tc"

          set -gu default-command
          set -g default-shell "$SHELL"

          bind '"' split-window -c "#{pane_current_path}"
          set-option -g renumber-windows on

          # restore the pane contents for sessions and for neovim
          set -g @continuum-restore 'on'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'

          # vim-like copy and pasting
          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          # tmux sessionizer
          bind -r '(' switch-client -p\; refresh-client -S
          bind -r ')' switch-client -n\; refresh-client -S

          bind C-t display-popup -E "tms" # find the sessions/repos
          bind C-j display-popup -E "tms switch" # switch the sessions
        '';
    };

    home.packages = with pkgs; [
      tmux-sessionizer
    ];
  };
}
