let
  font = "JetBrainsMono Nerd Font";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window.decorations = "buttonless";
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
          style = "Normal";
        };
      };
    };
  };
}
