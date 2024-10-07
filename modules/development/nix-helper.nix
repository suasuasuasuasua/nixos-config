{pkgs, ...}: let
  flake = /home/justin/Documents/nixos-config;
in {
  environment.systemPackages = with pkgs; [
    nom
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = flake;
  };
}
