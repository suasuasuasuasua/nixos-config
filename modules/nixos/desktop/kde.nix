{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.desktop.kde;
in
{
  options.nixos.desktop.kde = {
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
          elisa # music player
          filelight # disk usage
          fwupd
          haruna # video player
          hunspell # spell check
          hunspellDicts.en_US # US english package
          kate # text editor
          krita # photo editing
          kalendar # calendar
          libreoffice-qt # office suite -- calligra wasn't working
          plasmusic-toolbar
        ]
        ++ (with pkgs.kdePackages; [
          kmail # mail client
          kmail-account-wizard # mail client helper
          kwin # window manager (not sure why not installed by default?)
          plasma-thunderbolt # thunderbolt panel
        ]);

      plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        oxygen # app style
        kwrited # text editor
        kdevelop # text editor / ide
      ];
    };
  };
}
