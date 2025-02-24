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
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # 24.11 style
    # nerd-fonts.jetbrains-mono # ^25.05 style
  ];

  catppuccin = {
    # Enable and disable
    enable = false;
    flavor = "mocha";
    accent = "lavender";
  };
}
