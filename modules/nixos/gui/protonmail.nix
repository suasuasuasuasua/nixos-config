{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.protonmail;
in
{
  options.nixos.gui.protonmail = {
    enable = lib.mkEnableOption ''
      Desktop application for Mail and Calendar, made with Electron
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      protonmail-desktop
    ];
  };
}
