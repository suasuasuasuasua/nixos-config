{user, ...}: let
  font = "JetBrainsMono Nerd Font";
in {
  programs.kitty = {
    enable = true;
    font = {
      name = font;
    };
    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
