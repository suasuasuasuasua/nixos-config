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
    enable = lib.mkEnableOption ''
      Open Source implementation of the Windows API on top of X, OpenGL, and
      Unix
    '';
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
