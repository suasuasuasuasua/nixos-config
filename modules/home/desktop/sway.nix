{
  config,
  lib,
  ...
}:
let
  cfg = config.home.desktop.sway;
in
{
  options.home.desktop.alacritty = {
    enable = lib.mkEnableOption "Enable sway config";
    # TODO: finish
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;

      # validate the config file
      checkConfig = true;
      # config options
      config = { };
    };
  };
}
