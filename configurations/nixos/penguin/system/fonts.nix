{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # ^25.05 style
  ];
}
