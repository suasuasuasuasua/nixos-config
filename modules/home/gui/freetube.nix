{
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.freetube;
in
{
  options.home.gui.freetube = {
    enable = lib.mkEnableOption "Enable FreeTube";
  };

  config = lib.mkIf cfg.enable {
    programs.freetube = {
      enable = true;
      settings = { };
    };
  };
}
