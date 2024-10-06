{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    protonmail-bridge
    protonmail-bridge-gui
  ];
}
