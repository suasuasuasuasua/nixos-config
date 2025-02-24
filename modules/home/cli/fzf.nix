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
    enable = lib.mkEnableOption "Enable fzf";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
