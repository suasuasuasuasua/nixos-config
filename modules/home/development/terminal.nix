{
  config,
  lib,
  ...
}:
let
  font = "JetBrainsMono Nerd Font";

  cfg = config.home.development.terminal;
in
{
  options.home.development.terminal = {
    enable = lib.mkEnableOption "Enable a terminal emulator";
    # TODO: add options for terminal emulator
    # TODO: add options for font
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
            family = font;
            style = "Bold";
          };
          italic = {
            family = font;
            style = "Italic";
          };
          bold_italic = {
            family = font;
            style = "Bold Italic";
          };
          normal = {
            family = font;
            style = "Regular";
          };
        };
      };
    };
  };
}
