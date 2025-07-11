{
  lib,
  config,
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
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };
}
