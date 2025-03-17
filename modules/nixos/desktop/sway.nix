{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.desktop.sway;
in
{
  options.nixos.desktop.sway = {
    enable = lib.mkEnableOption "Enable Sway desktop environment";
    # TODO: fill in blah blah
  };

  config = lib.mkIf cfg.enable {
    # enable Sway window manager
    programs = {
      light.enable = true;
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };
      waybar.enable = true;
    };

    # Installing a greeter based on greetd is the most straightforward way to
    # launch Sway.
    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
            user = "greeter";
          };
        };
      };
    };

    # To set up Sway using Home Manager, first you must enable Polkit in your
    # NixOS configuration
    security.polkit.enable = true;

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
      grim # screenshot functionality
      mako # notification system developed by swaywm maintainer
      pulseaudio
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];
  };
}
