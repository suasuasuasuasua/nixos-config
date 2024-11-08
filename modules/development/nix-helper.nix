{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nom
  ];

  programs.nh = {
    enable = true;
  };
}
