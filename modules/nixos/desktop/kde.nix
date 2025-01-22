{ pkgs, ... }:
{
  services.displayManager.ly.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  # Add these kde packages
  environment.systemPackages =
    with pkgs; [
      filelight # disk usage
      kate # text editor
      krita # photo editing
      kdenlive # video editing
      haruna # video player
      elisa # music player
      kalendar # calendar
      catppuccin-kde # global theme
      libreoffice-qt # office suite -- calligra wasn't working
      hunspell # spell check
      hunspellDicts.en_US # US english package
    ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    oxygen # app style
    kwrited # text editor
    kdevelop # text editor / ide
  ];
}
