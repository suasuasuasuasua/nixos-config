{
  config,
  lib,
  ...
}:
let
  cfg = config.home.gui.alacritty;
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
          # decorations = "None";
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };
  };
}
