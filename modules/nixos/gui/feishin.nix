{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.feishin;
in
{
  options.nixos.gui.feishin = {
    enable = lib.mkEnableOption ''
      Full-featured Subsonic/Jellyfin compatible desktop music player
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      feishin
    ];
  };
}
