{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    appflowy
  ];
}
