{
  config,
  lib,
  ...
}:
let
  cfg = config.home.desktop.sway;
in
{
  options.home.desktop.alacritty = {
    enable = lib.mkEnableOption "Enable sway config";
    # TODO: finish
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;

      # validate the config file
      checkConfig = true;
      # config options
      config = rec {
        # logo key; Mod1 for Alt, Mod4 for Win
        modifier = "Mod1";

        # home row direction keys, live vim
        left = "h";
        down = "j";
        up = "k";
        right = "l";

        # preferred terminal emulator
        terminal = "\${pkgs.foot}/bin/foot";

        # Your preferred application launcher
        # Note: pass the final command to swaymsg so that the resulting window
        # can be opened on the original workspace that the command was run on.
        menu = "dmenu_path | dmenu | xargs swaymsg exec --";

        ### Output configuration
        # TODO: modularize these display setting for other computers
        output = {
          # TODO: modularize wallpaper
          # Default wallpaper (more resolutions are available in /usr/share/backgrounds/sway/)
          "* bg" = "/usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
          #
          # Example configuration:
          #
          #   output HDMI-A-1 resolution 1920x1080 position 1920,0
          #
          # You can get the names of your outputs by running: swaymsg -t
          # get_outputs laptop display example
          "DP-1" = {
            scale = 1.5;
            mode = "2560x1440@165Hz";
          };
        };
      };
    };
  };
}
