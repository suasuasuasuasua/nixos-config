{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.home.cli.zellij;
in
{
  options.custom.home.cli.zellij = {
    enable = lib.mkEnableOption ''
      Terminal workspace with batteries included
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;

      enableZshIntegration = true;
      attachExistingSession = true;
      settings = { };
    };
  };
}
