{
  pkgs,
  inputs,
  ...
}: let
  flavor = "mocha";
  accent = "lavender";
in {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["JetBrainsMono"];
    })
  ];

  catppuccin = {
    enable = true;
    accent = "${accent}";
    flavor = "${flavor}";
  };
}
