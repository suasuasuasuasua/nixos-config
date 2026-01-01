{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.gui.alacritty;

  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  options.custom.home.gui.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
          # transparent and buttonless is macOS only
          decorations = lib.mkIf isDarwin "Buttonless";
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };
  };
}
