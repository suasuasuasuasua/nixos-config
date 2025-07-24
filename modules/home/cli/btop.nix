{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.home.cli.btop;
in
{
  options.custom.home.cli.btop = {
    enable = lib.mkEnableOption ''
      Monitor of resources
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;
      # https://github.com/aristocratos/btop#configurability
      settings = {
        # NOTE: controlled by stylix
        # color_theme = "tokyo-night";
        theme_background = true;
      };
    };
  };
}
