{
  pkgs,
  ...
}:
{
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) # 24.11 style
    # nerd-fonts.jetbrains-mono # ^25.05 style
  ];
}
