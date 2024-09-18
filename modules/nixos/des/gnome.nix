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
    gnome-tour
    gnome-connections
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ];
}
