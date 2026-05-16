{ pkgs, ... }:
{
  services = {
    xserver.enable = true;
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      # Required for headless use: gnome-remote-desktop attaches to a running
      # session, so one must exist before any RDP client connects.
      autoLogin = {
        enable = true;
        user = "justinhoang";
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  programs.firefox.enable = true;
}
