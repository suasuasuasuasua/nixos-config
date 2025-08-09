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
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableZshIntegration = true;
      settings = { };
    };
  };
}
