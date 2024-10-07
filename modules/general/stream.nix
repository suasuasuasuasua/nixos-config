{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obs-studio
    obs-cli
  ];
}
