{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.discord;
in
{
  options.darwin.gui.discord = {
    enable = lib.mkEnableOption "Enable Discord";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
