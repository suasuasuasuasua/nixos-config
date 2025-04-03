{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.firefox;
in
{
  options.home.gui.firefox = {
    enable = lib.mkEnableOption "Enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: firefox is in unstable for darwin...remove in may 2025
      package = with pkgs; if stdenv.isDarwin then unstable.firefox else firefox;
      # TODO: figure out profiles
    };
  };
}
