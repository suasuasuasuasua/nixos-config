{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.obs;
in
{
  options.darwin.gui.obs = {
    enable = lib.mkEnableOption "Enable OBS";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obs-studio
    ];
  };
}
