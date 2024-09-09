{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    thunderbird
    spotify
    discord

    filelight
    timeshift
    yazi
    fastfetch
    btop
    imv
    mpv
    zathura
  ];
}
