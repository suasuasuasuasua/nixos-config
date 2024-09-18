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

  services.gnome.core-utilities.enable = false;
  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  programs.dconf.enable = true;

  # Add these gnome packages
  environment.systemPackages =
    (with pkgs; [
      nautilus # file browser
      baobab # disk usage analyzer
      gnome-disk-utility
      gnome-boxes
      gnome-tweaks
    ])
    ++ (with pkgs.gnomeExtensions; [
      # TODO: find extensions that I like
      # Add these gnome extensions
      # blur-my-shell
      # pop-shell
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
    file-roller # archive manager
    geary # email client
    seahorse # password manager

    # these should be self explanatory
    gnome-calculator
    gnome-calendar
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
    gnome-weather
    gnome-connections
  ];
}
