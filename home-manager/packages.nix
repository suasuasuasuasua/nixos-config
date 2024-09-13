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
    # General Apps
    thunderbird
    spotify
    discord

    # Development
    github-desktop
    devenv
    bat
    diff-so-fancy
  ];
}
