{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.obs;
in
{
  options.nixos.gui.obs = {
    enable = lib.mkEnableOption "Enable OBS";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      # Add any plugins for OBS studio
      plugins = with pkgs.obs-studio-plugins; [
      ];

      # TODO: many options for OBS
    };
  };
}
