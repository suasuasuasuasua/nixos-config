{
  pkgs,
  flake,
  ...
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
    # Enable and disable
    enable = false;
    flavor = "mocha";
    accent = "lavender";
  };
}
