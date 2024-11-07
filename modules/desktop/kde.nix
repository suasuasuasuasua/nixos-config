{pkgs, ...}: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  # Add these kde packages
  environment.systemPackages = with pkgs; [
    filelight # disk usage
    krita # photo editing
    kdenlive # video editing
    catppuccin-kde # theme
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa # music
    oxygen # app style
    kate # text editor
    kwrited # text editor
    kdevelop # text editor / ide
  ];
}
