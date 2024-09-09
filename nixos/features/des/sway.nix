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
    grim # screenshot functionality
    slurp # screenshot functionality
    swayidle
    swaylock
    pamixer
    wob
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wf-recorder
    mako # notification system developed by swaywm maintainer
    waybar # status bar
    ly # sign in
    fuzzel # application launcher

    yazi
    imv
    mpv
    btop
  ];
}
