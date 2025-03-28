{
  lib,
  config,
  ...
}:
let
  cfg = config.home.cli.fzf;
in
{
  options.home.cli.fzf = {
    enable = lib.mkEnableOption ''
      Command-line fuzzy finder written in Go
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
