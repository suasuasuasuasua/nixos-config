{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-rounded;
      extraPackages = [
        pkgs.dmenu # application launcher most people use
        pkgs.i3status # gives you the default i3 status bar
        pkgs.i3lock # default i3 screen locker
      ];
    };
  };

  services.displayManager.ly.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
