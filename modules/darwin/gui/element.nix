{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.element;
in
{
  options.darwin.gui.element = {
    enable = lib.mkEnableOption "Enable Element";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # The electron client (prettiest)
      element-desktop
    ];
  };
}
