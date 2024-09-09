{
  inputs,
  pkgs,
  ...
}: {
  services.xserver.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    kate
    konsole
    oxygen
  ];
}
