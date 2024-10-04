{
  inputs,
  ...
}: let
  flavor = "mocha";
  accent = "lavender";
in {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    accent = "${accent}";
    flavor = "${flavor}";
  };
}
