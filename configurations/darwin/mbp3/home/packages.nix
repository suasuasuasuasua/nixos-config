{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # appcleaner
    # bitwarden-cli # TODO: broken on darwin
    # iterm2 # NOTE: native terminal app is pretty good now
    appflowy
    betterdisplay
    bitwarden-desktop
    discord
    feishin
    hidden-bar
    iina
    obsidian
    podman
    podman-tui
    shottr
    utm
    zathura
  ];
}
