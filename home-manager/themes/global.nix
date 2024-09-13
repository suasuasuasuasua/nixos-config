{ inputs, ... }:
let
  flavor = "mocha";
  accent = "lavender";
in
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin.enable = true;
  catppuccin.flavor = "${flavor}";
  catppuccin.accent = "${accent}";

  catppuccin.pointerCursor = {
    enable = true;
    accent = "${accent}";
  };
}
