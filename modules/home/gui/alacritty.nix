{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.alacritty;

  inherit (pkgs.stdenv.hostPlatform) isLinux;
in
{
  options.home.gui.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
          decorations =
            if isLinux then
              "None"
            else
              # transparent and buttonless is macOS only
              "Buttonless";
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };
  };
}
