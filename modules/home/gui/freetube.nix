{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.home.gui.freetube;
in
{
  options.custom.home.gui.freetube = {
    enable = lib.mkEnableOption "Enable FreeTube";
  };

  config = lib.mkIf cfg.enable {
    programs.freetube = {
      enable = true;
      settings = { };
    };
  };
}
