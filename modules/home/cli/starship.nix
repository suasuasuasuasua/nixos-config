{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.home.cli.starship;
in
{
  options.custom.home.cli.starship = {
    enable = lib.mkEnableOption ''
      Minimal, blazing fast, and extremely customizable prompt for any shell
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableZshIntegration = true;
      settings = { };
    };
  };
}
