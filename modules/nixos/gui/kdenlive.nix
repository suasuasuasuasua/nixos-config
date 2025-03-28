{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.kdenlive;
in
{
  options.nixos.gui.kdenlive = {
    enable = lib.mkEnableOption ''
      Free and open source video editor, based on MLT Framework and KDE
      Frameworks
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
    ];
  };
}
