{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.home.gui.obs;
in
{
  options.custom.home.gui.obs = {
    enable = lib.mkEnableOption "Enable OBS";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [ ];
    };
  };
}
