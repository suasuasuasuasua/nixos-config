{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.nixos.desktop.gnome;
in
{
  options.custom.nixos.desktop.gnome = {
    enable = lib.mkEnableOption "Enable Gnome desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };

      gnome.core-apps.enable = true;
      udev.packages = [ pkgs.gnome-settings-daemon ];

    };
    programs.dconf.enable = true;

    # Add these gnome packages
    environment.systemPackages = [
      pkgs.eog # image viewer
      pkgs.totem # video player
      pkgs.evince # document viewer
      pkgs.baobab # disk usage analyzer
      pkgs.file-roller # archive manager
      pkgs.nautilus # file browser
      pkgs.dialect # translator
      pkgs.shotcut # video editor
      pkgs.libreoffice-qt # office suite
      pkgs.hunspell # spell check (for office suite)
      pkgs.hunspellDicts.en_US
      pkgs.gnome-calendar
      pkgs.gnome-disk-utility
      pkgs.lollypop
      pkgs.gnome-boxes
      pkgs.gnome-tweaks
    ]
    ++ [
      # Add these gnome extensions
      pkgs.gnomeExtensions.tray-icons-reloaded
      pkgs.gnomeExtensions.open-bar
    ];

    # Remove these gnome packages from the default installation
    environment.gnome.excludePackages = [
      pkgs.cheese # photo booth
      pkgs.epiphany # web browser
      pkgs.gedit # text editor
      pkgs.simple-scan # document scanner
      pkgs.yelp # help viewer
      pkgs.geary # email client
      pkgs.seahorse # password manager

      # these should be self explanatory
      pkgs.gnome-calculator
      pkgs.gnome-characters
      pkgs.gnome-clocks
      pkgs.gnome-contacts
      pkgs.gnome-font-viewer
      pkgs.gnome-logs
      pkgs.gnome-maps
      pkgs.gnome-music
      pkgs.gnome-photos
      pkgs.gnome-screenshot
      pkgs.gnome-system-monitor
      pkgs.gnome-tour
      pkgs.gnome-weather
      pkgs.gnome-connections
    ];
  };
}
