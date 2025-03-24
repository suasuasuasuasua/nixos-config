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
    # TODO: add options for enabling display managers like sddm, ly, etc.
    # TODO: add options for specific packages and default to below list
  };

  config = lib.mkIf cfg.enable {
    services = {
      displayManager.ly.enable = true;
      # displayManager.sddm.enable = true;
      # displayManager.sddm.wayland.enable = true;

      desktopManager.plasma6.enable = true;
      displayManager.defaultSession = "plasma";

    };
    # Add these kde packages
    environment.systemPackages =
      with pkgs;
      [
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
      ]
      ++ (with pkgs.kdePackages; [
        koi # light/dark switcher
        kmail # mail client
        kmail-account-wizard # mail client helper
        kwin # window manager (not sure why not installed by default?)
        plasma-thunderbolt # thunderbolt panel
      ]);

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      oxygen # app style
      kwrited # text editor
      kdevelop # text editor / ide
    ];
  };
}
