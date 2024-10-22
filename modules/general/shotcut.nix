{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    shotcut
  ];
}
