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
    services.displayManager.ly.enable = true;
    # services.displayManager.sddm.enable = true;
    # services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.defaultSession = "plasma";

    # Add these kde packages
    environment.systemPackages =
      with pkgs;
      [
        filelight # disk usage
        kate # text editor
        krita # photo editing
        kdenlive # video editing
        haruna # video player
        elisa # music player
        kalendar # calendar
        libreoffice-qt # office suite -- calligra wasn't working
        hunspell # spell check
        hunspellDicts.en_US # US english package
        # macos-like theme
        whitesur-kde
        whitesur-cursors
        whitesur-icon-theme
      ]
      ++ (with pkgs.kdePackages; [
        plasma-thunderbolt
      ]);

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      oxygen # app style
      kwrited # text editor
      kdevelop # text editor / ide
    ];
  };
}
