{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.nixos.desktop.kde;
in
{
  options.custom.nixos.desktop.kde = {
    enable = lib.mkEnableOption "Enable KDE desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        autoNumlock = true;
      };

      desktopManager.plasma6.enable = true;
      displayManager.defaultSession = "plasma";
    };

    environment = {
      sessionVariables.PLASMA_USE_QT_SCALING = "1";

      # Add these kde packages
      systemPackages = [
        pkgs.application-title-bar
        pkgs.dmidecode
        pkgs.fwupd
        pkgs.hunspell # spell check
        pkgs.hunspellDicts.en_US # US english package
        pkgs.libreoffice-qt # office suite -- calligra wasn't working
        pkgs.plasmusic-toolbar
      ]
      ++ [
        pkgs.kdePackages.elisa # music player
        pkgs.kdePackages.filelight # disk usage
        pkgs.kdePackages.haruna # video player
        pkgs.kdePackages.kate # text editor
        pkgs.kdePackages.kdeconnect-kde # connect with devices
        pkgs.kdePackages.kgpg # gnupg client
        pkgs.kdePackages.kmail # mail client
        pkgs.kdePackages.kmail-account-wizard # mail client helper
        pkgs.kdePackages.krita # photo editing
        pkgs.kdePackages.kwin # window manager (not sure why not installed by default?)
        pkgs.kdePackages.merkuro # app suite
        pkgs.kdePackages.plasma-thunderbolt # thunderbolt panel
        pkgs.kdePackages.yakuake # drop down terminal
      ];

      plasma6.excludePackages = [
        pkgs.kdePackages.plasma-browser-integration
        pkgs.kdePackages.oxygen # app style
        pkgs.kdePackages.kwrited # text editor
        pkgs.kdePackages.kdevelop # text editor / ide
      ];
    };

    networking.firewall = {
      # KDE connect ports
      # https://userbase.kde.org/KDEConnect#Troubleshooting
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
