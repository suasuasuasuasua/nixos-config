{
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.firefox;
in
{
  options.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: figure out profiles
    };
  };
}
