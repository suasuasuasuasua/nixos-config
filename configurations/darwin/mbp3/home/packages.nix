{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # bitwarden-cli # TODO: broken on darwin
    # iterm2 # NOTE: native terminal app is pretty good now
    appcleaner
    appflowy
    betterdisplay
    bitwarden-desktop
    discord
    feishin
    hidden-bar
    iina
    nodejs_24
    obsidian
    podman
    podman-tui
    python314
    shottr
    utm
    zathura
  ];
}
