{ pkgs, lib, ... }:
{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    image = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/MilkyWay/contents/images/5120x2880.png";

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
        # package = pkgs.nerd-fonts.jetbrains-mono;
        # name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      qt = {
        enable = true;
        platform = lib.mkForce "qtct";
      };
    };
  };
}
