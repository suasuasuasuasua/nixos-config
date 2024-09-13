let
  flavor = "mocha";
  accent = "lavender";
in {
  catppuccin.enable = true;
  catppuccin.flavor = "${flavor}";
  catppuccin.accent = "${accent}";

  catppuccin.pointerCursor = {
    enable = true;
    accent = "${accent}";
  };
}
