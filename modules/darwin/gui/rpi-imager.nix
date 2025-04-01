{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.rpi-imager;
in
{
  options.darwin.gui.rpi-imager = {
    enable = lib.mkEnableOption "Enable Raspberry Pi Imager";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rpi-imager
    ];
  };
}
