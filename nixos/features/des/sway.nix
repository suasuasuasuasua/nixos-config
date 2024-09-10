{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable Sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  environment.systemPackages = with pkgs; [
    grim
    slurp
    swayidle
    swaylock
    pamixer
    wob
    wl-clipboard
    wf-recorder
    mako
    waybar
    ly
    fuzzel
    zathura
    yazi
    imv
    mpv
  ];
}
