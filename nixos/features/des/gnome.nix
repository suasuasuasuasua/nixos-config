{
  inputs,
  pkgs,
  ...
}: {
  services.xserver.enable = true;

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.gnome.core-utilities.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-boxes
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany
    geary
    evince
  ];
}
