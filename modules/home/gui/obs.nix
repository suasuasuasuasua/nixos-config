{
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.obs;
in
{
  options.home.gui.obs = {
    enable = lib.mkEnableOption "Enable general CLI tools";
    # TODO: add options for packages for custom config
    # TODO: add options for theme
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      # TODO: figure out which plugins we want
      plugins = [ ];
    };
  };
}
