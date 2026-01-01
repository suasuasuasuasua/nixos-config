{
  config,
  lib,
  pkgs,
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
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.btop;
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: add suid bits to allow gpu and wattage monitoring without explicit
    # `sudo btop`
    programs.btop = {
      inherit (cfg) package;

      enable = true;
      # https://github.com/aristocratos/btop#configurability
      settings = {
        # NOTE: controlled by stylix
        # color_theme = "tokyo-night";
        theme_background = true;
        update_ms = 100; # ms
      };
    };
  };
}
