{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    typst
    typstyle
  ];
}
