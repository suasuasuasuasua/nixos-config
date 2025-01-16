{ pkgs
, flake
, ...
}:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "lavender";
  };
}
