{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.cli.tmux;
in
{
  options.custom.home.cli.tmux = {
    enable = lib.mkEnableOption ''
      Terminal multiplexer
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        fpp # find and open files in the current buffer
        {

          plugin = resurrect; # save sessions past system restarts
          extraConfig =
            # tmux
            ''
              resurrect_dir=~/.tmux/resurrect/
              set -g @resurrect-dir $resurrect_dir
              set -g @resurrect-hook-post-save-all "sed -i 's| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/nix/store/.*/bin/||g' $(readlink -f $resurrect_dir/last)"

              # restore the pane contents for sessions and for neovim
              set -g @resurrect-capture-pane-contents 'on'
              set -g @resurrect-strategy-vim 'session'
              set -g @resurrect-strategy-nvim 'session'
            '';
        }
        {
          plugin = continuum; # continuous saving and start of tmux
          extraConfig =
            # tmux
            ''
              # restore the pane contents for sessions and for neovim
              set -g @continuum-restore 'on'
              set -g @continuum-boot 'on'
              set -g @continuum-save-interval '10'
            '';
        }
        sensible # sensible config
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

          bind 'c' new-window -c "#{pane_current_path}"
          bind '"' split-window -c "#{pane_current_path}"
          bind '%' split-window -h -c "#{pane_current_path}"
          set-option -g renumber-windows on

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
