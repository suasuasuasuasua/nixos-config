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
    enable = lib.mkEnableOption "Enable tmux";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        continuum
        yank
        fpp
        vim-tmux-navigator

        # Enable and disable the theme
        # catppuccin
      ];

      sensibleOnTop = false;
      mouse = true;
      prefix = "C-Space";
      keyMode = "vi";
      baseIndex = 1;

      extraConfig =
        # tmux
        ''
          set-option -sa terminal-overrides ",xterm*:Tc"

          bind '"' split-window -c "#{pane_current_path}"
          set-option -g renumber-windows on

          # restore the pane contents for sessions and for neovim
          set -g @continuum-restore 'on'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        '';
    };
  };
}
