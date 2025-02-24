{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.element;
in
{
  options.nixos.gui.element = {
    enable = lib.mkEnableOption "Enable Element";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # The electron client (prettiest)
      element-desktop
    ];
  };
}
