{ pkgs, ... }: {
  services = {
    xserver.enable = true;
    desktopManager.plasma6.enable = true;
    displayManager.defaultSession = "plasmax11";
  };

  # VA-API for Intel UHD 630 (needed for Sunshine hardware encoding)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # iHD driver, required for 8th-gen+ Intel (i5-8600T)
    ];
  };

  programs.firefox.enable = true;
}
