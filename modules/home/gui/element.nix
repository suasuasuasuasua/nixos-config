{
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.element-desktop;
in
{
  options.home.gui.element-desktop = {
    enable = lib.mkEnableOption "Enable Element Desktop Matrix Client";
  };

  config = lib.mkIf cfg.enable {
    programs.element-desktop = {
      enable = true;
      profiles = { };
      settings = { };
    };
  };
}
