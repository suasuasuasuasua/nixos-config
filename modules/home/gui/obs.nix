{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.gui.obs;
in
{
  options.custom.home.gui.obs = {
    enable = lib.mkEnableOption "Enable OBS";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.obs-studio;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      inherit (cfg) package;

      enable = true;
      plugins = [ ];
    };
  };
}
