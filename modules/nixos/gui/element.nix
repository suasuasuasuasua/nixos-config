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
    enable = lib.mkEnableOption ''
      A feature-rich client for Matrix.org
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      element-desktop
    ];
  };
}
