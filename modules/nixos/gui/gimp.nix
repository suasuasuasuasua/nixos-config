{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.gimp;
in
{
  options.nixos.gui.gimp = {
    enable = lib.mkEnableOption "Enable gimp";
    # TODO: add extra libraries and packages?
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp
    ];
  };
}
