{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.wine;
in
{
  options.nixos.gui.wine = {
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
