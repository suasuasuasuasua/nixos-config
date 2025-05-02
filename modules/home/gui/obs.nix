{
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.obs;
in
{
  options.home.gui.obs = {
    enable = lib.mkEnableOption "Enable OBS";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [ ];
    };
  };
}
