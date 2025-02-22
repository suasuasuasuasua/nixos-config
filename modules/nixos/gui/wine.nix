{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gui.wine;
in
{
  options.gui.wine = {
    enable = lib.mkEnableOption "Enable Wine";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (wineWowPackages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
      winetricks
    ];
  };
}
