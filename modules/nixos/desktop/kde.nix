{
  lib,
  config,
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
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
        };
      };

      desktopManager.plasma6.enable = true;
      displayManager.defaultSession = "plasma";

    };

    environment = {
      sessionVariables = {
        PLASMA_USE_QT_SCALING = "1";
      };

      # Add these kde packages
      systemPackages =
        with pkgs;
        [
          application-title-bar
          dmidecode
          fwupd
          hunspell # spell check
          hunspellDicts.en_US # US english package
          libreoffice-qt # office suite -- calligra wasn't working
          plasmusic-toolbar
        ]
        ++ (with pkgs.kdePackages; [
          elisa # music player
          filelight # disk usage
          haruna # video player
          kate # text editor
          kdeconnect-kde # connect with devices
          kgpg # gnupg client
          kmail # mail client
          kmail-account-wizard # mail client helper
          krita # photo editing
          kwin # window manager (not sure why not installed by default?)
          merkuro # app suite
          plasma-thunderbolt # thunderbolt panel
          yakuake # drop down terminal
        ]);

      plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        oxygen # app style
        kwrited # text editor
        kdevelop # text editor / ide
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
