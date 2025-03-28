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

    # TODO: add better options for font
    font = lib.mkOption {
      type = lib.types.str;
      default = "JetBrainsMono Nerd Font";
    };
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
        font = {
          size = 10;
          bold = {
            family = cfg.font;
            style = "Bold";
          };
          italic = {
            family = cfg.font;
            style = "Italic";
          };
          bold_italic = {
            family = cfg.font;
            style = "Bold Italic";
          };
          normal = {
            family = cfg.font;
            style = "Regular";
          };
        };
      };
    };
  };
}
