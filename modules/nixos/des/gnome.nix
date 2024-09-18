{
  inputs,
  pkgs,
  ...
}: {
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
      baobab # disk usage analyzer
      file-roller # archive manager
      nautilus # file browser
      gnome-calendar
      gnome-disk-utility
      gnome-boxes
      gnome-tweaks
    ])
    ++ (with pkgs.gnomeExtensions; [
      # TODO: find extensions that I like
      # Add these gnome extensions
      tray-icons-reloaded
    ]);

  # Remove these gnome packages from the default installation
  environment.gnome.excludePackages = with pkgs; [
    cheese # photo booth
    eog # image viewer
    epiphany # web browser
    gedit # text editor
    simple-scan # document scanner
    totem # video player
    yelp # help viewer
    evince # document viewer
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
