{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.home.desktop.sway;
in
{
  options.home.desktop.sway = {
    enable = lib.mkEnableOption "Enable sway home manager config";
    modifier = lib.mkOption {
      type = lib.types.str;
      default = "Mod1";
      description = ''
        logo key; Mod1 for Alt, Mod4 for Win
      '';
    };
    input = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf str);
      default = { };
      description = ''
        do `swaymsg -t get_inputs` to find available options
      '';
    };
    output = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf str);
      default = { };
      description = ''
        do `swaymsg -t get_outputs` to find available options
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # main sway configuration
    wayland.windowManager.sway = {
      enable = true;

      # validate the config file
      checkConfig = true;
      # config options
      config = rec {
        inherit (cfg) modifier input output;

        # home row direction keys, live vim
        left = "h";
        down = "j";
        up = "k";
        right = "l";

        # TODO: not sure why declaring it explicitly breaks??
        # preferred terminal emulator
        terminal = "${pkgs.foot}/bin/foot";

        # TODO: not sure why declaring it explicitly breaks??
        # Your preferred application launcher
        # Note: pass the final command to swaymsg so that the resulting window
        # can be opened on the original workspace that the command was run on.
        menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";

        modes = {
          # mod+r to activate resizing mode
          resize =
            let
              factor = "10";
            in
            rec {
              Escape = "mode default";
              Return = "mode default";

              Left = "resize shrink width ${factor} px";
              Down = "resize grow height ${factor} px";
              Up = "resize shrink height ${factor} px";
              Right = "resize grow width ${factor} px";
              # reuse the bindings defined above
              ${left} = Left;
              ${down} = Down;
              ${up} = Up;
              ${right} = Right;
            };
        };

        # tap $mod+X to return to previous location
        workspaceAutoBackAndForth = true;

        # Disable the original bars using waybar right now
        bars = [ ];

        gaps = {
          inner = 5;
          outer = 5;
          smartBorders = "on";
          smartGaps = true;
        };
      };
    };

    # enable locking of the device
    programs.swaylock = {
      enable = true;
      settings = { };
    };

    # enable idling
    services.swayidle = {
      enable = true;
      ### Idle configuration
      #
      # Example configuration:
      #
      # exec swayidle -w \
      #          timeout 300 'swaylock -f -c 000000' \
      #          timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
      #          before-sleep 'swaylock -f -c 000000'
      #
      # This will lock your screen after 300 seconds of inactivity, then turn
      # off your displays after another 300 seconds, and turn your screens back
      # on when resumed. It will also lock your screen before your computer goes
      # to sleep.
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF -c 000000";
        }
        {
          event = "lock";
          command = "lock";
        }
      ];

      timeouts = [
        {
          timeout = 300;
          command = "${pkgs.swaylock}/bin/swaylock -fF -c 000000";
        }
        {
          timeout = 600;
          command = "${pkgs.systemd}/bin/systemctl suspend";
          # command = "${pkgs.swaymsg}/bin/swaymsg output * dpms off";
        }
      ];
    };
  };
}
