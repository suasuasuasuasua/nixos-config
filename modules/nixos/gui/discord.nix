{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gui.discord;
in
{
  options.gui.discord = {
    enable = lib.mkEnableOption "Enable Discord";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.discord
    ];
  };
}
