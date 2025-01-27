{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };

  services.gnome.core-utilities.enable = true;
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  programs.dconf.enable = true;

  # Add these gnome packages
  environment.systemPackages =
    (with pkgs; [
      eog # image viewer
      totem # video player
      evince # document viewer
      baobab # disk usage analyzer
      file-roller # archive manager
      nautilus # file browser
      dialect # translator
      shotcut # video editor
      gimp # photo editor
      libreoffice-qt # office suite
      hunspell # spell check (for office suite)
      hunspellDicts.en_US
      gnome-calendar
      gnome-disk-utility
      lollypop
      gnome-boxes
      gnome-tweaks
    ])
    ++ (with pkgs.gnomeExtensions; [
      # Add these gnome extensions
      tray-icons-reloaded
      open-bar
    ]);

  # Remove these gnome packages from the default installation
  environment.gnome.excludePackages = with pkgs; [
    cheese # photo booth
    epiphany # web browser
    gedit # text editor
    simple-scan # document scanner
    yelp # help viewer
    geary # email client
    seahorse # password manager

    # these should be self explanatory
    gnome-calculator
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-system-monitor
    gnome-tour
    gnome-weather
    gnome-connections
  ];
}
