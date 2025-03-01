{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.discord;
in
{
  options.nixos.gui.discord = {
    enable = lib.mkEnableOption "Enable Discord";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
