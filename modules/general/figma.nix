{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    figma-linux
  ];
}
