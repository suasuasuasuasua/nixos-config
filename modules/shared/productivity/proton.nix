{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    protonmail-desktop
    protonmail-bridge
    protonmail-bridge-gui
    protonvpn-gui
    protonvpn-cli
  ];
}
