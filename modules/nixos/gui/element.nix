{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gui.element;
in
{
  options.gui.element = {
    enable = lib.mkEnableOption "Enable Element";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # The electron client (prettiest)
      element-desktop
    ];
  };
}
