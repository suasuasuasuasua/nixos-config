let
  font = "JetBrainsMono Nerd Font";
in {
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    font = {
      size = 10;
      name = font;
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
