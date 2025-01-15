{ pkgs
, flake
, ...
}:
let
  flavor = "mocha";
  accent = "lavender";
in
{
  imports = [
    flake.inputs.catppuccin.nixosModules.catppuccin
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
