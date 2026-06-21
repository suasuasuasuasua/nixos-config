{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.cli.fzf;
in
{
  options.custom.home.cli.fzf = {
    enable = lib.mkEnableOption ''
      Command-line fuzzy finder written in Go
    '';
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fd ];

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    programs.zsh.initContent = ''
      export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
      export FZF_CTRL_T_COMMAND="rg --files --hidden --glob '!.git'"
      export FZF_ALT_C_COMMAND="fd -t d --hidden --exclude .git"
    '';
  };
}
