let
  font = "JetBrainsMono Nerd Font";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      font.size = 10;
      font.bold = {
        family = font;
        style = "Bold";
      };
      font.italic = {
        family = font;
        style = "Italic";
      };
      font.bold_italic = {
        family = font;
        style = "Bold Italic";
      };
      font.normal = {
        family = font;
        style = "Normal";
      };
    };
  };
}
