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
    nerd-fonts.jetbrains-mono
  ];

  catppuccin = {
    enable = true;
    accent = "${accent}";
    flavor = "${flavor}";
  };
}
