{inputs, ...}: let
  flavor = "mocha";
  accent = "lavender";
in {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];
  catppuccin.enable = true;
  catppuccin.flavor = "${flavor}";
  catppuccin.accent = "${accent}";

  # TODO: how to toggle this for aarch64-darwin vs x86_64-linux?
  # catppuccin.pointerCursor = {
  #   enable = true;
  #   accent = "${accent}";
  # };

  # gtk = {
  #   enable = true;
  #   catppuccin = {
  #     accent = "${accent}";
  #     flavor = "${flavor}";
  #     icon = {
  #       enable = true;
  #       accent = "${accent}";
  #       flavor = "${flavor}";
  #     };
  #   };
  # };
}
