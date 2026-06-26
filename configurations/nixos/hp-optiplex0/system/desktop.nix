{
  services = {
    xserver = {
      enable = true;

      desktopManager = {
        xfce.enable = true;
        xterm.enable = false;
      };
    };

    displayManager.defaultSession = "xfce";
  };
}
