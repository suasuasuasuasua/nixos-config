{
  pkgs,
  config,
  lib,
  user,
  ...
}: let
  font = "JetBrainsMono Nerd Font";
  mod = "Mod4";
  terminal = "${user.terminal}";
  menu = "fuzzel --font ${font} --dpi-aware auto | xargs swaymsg exec --";
  left = "h";
  down = "j";
  up = "k";
  right = "l";

  border_size = 2;
  gap_size = 5;
in {
  wayland.windowManager.sway.config = {
    systemd.enable = true;
    checkConfig = true;

    # Modifier key for all the actions
    # Mod1 = Alt, Mod4 = Super
    modifier = "${mod}";

    # Home row direction keys like vim
    left = left;
    down = down;
    up = up;
    right = right;

    # Set the preferred terminal emulator
    terminal = terminal;

    # Preferred application launcher
    menu = menu;

    keybindings = {
      # Launch the terminal
      "${mod}+Return" = "exec ${terminal}";

      # Kill the current app
      "${mod}+Shift+q" = "kill";

      # Call the app launcher
      "${mod}+d" = "exec ${menu}";

      # Reload the configuration file
      "${mod}+Shift+c" = "reload";

      # Exit sway
      "${mod}+Shift+e" = ''
        exec swaynag -t warning -m 'You pressed the
        exit shortcut. Do you really want to exit sway? This will end your
        Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'
      '';

      ## Moving around:
      # Move focus around
      "${mod}+${left}" = "focus left";
      "${mod}+${down}" = "focus down";
      "${mod}+${up}" = "focus up";
      "${mod}+${right}" = "focus right";
      # Move focus around (or with arrows)
      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";

      # Move the focused window, but add Shift
      "${mod}+Shift+${left}" = "focus left";
      "${mod}+Shift+${down}" = "focus down";
      "${mod}+Shift+${up}" = "focus up";
      "${mod}+Shift+${right}" = "focus right";
      # Move focus around (or with arrows)
      "${mod}+Shift+Left" = "focus left";
      "${mod}+Shift+Down" = "focus down";
      "${mod}+Shift+Up" = "focus up";
      "${mod}+Shift+Right" = "focus right";

      ## Workspaces
      # Switch to a workspace
      "${mod}+1" = "workspace number 1";
      "${mod}+2" = "workspace number 2";
      "${mod}+3" = "workspace number 3";
      "${mod}+4" = "workspace number 4";
      "${mod}+5" = "workspace number 5";
      "${mod}+6" = "workspace number 6";
      "${mod}+7" = "workspace number 7";
      "${mod}+8" = "workspace number 8";
      "${mod}+9" = "workspace number 9";
      "${mod}+10" = "workspace number 10";
      # Move a focused container to another workspace
      "${mod}+Shift+1" = "move container to workspace number 1";
      "${mod}+Shift+2" = "move container to workspace number 2";
      "${mod}+Shift+3" = "move container to workspace number 3";
      "${mod}+Shift+4" = "move container to workspace number 4";
      "${mod}+Shift+5" = "move container to workspace number 5";
      "${mod}+Shift+6" = "move container to workspace number 6";
      "${mod}+Shift+7" = "move container to workspace number 7";
      "${mod}+Shift+8" = "move container to workspace number 8";
      "${mod}+Shift+9" = "move container to workspace number 9";
      "${mod}+Shift+10" = "move container to workspace number 10";
      # Note: workspaces can have any name you want, not just numbers.
      # We just use 1-10 as the default.

      ## Layout
      # Split horizontal or vertical
      "${mod}+b" = "splith";
      "${mod}+v" = "splitv";

      # Switch the current container between layout styles
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "tabbed";
      "${mod}+e" = "toggle split";

      # Full screen
      "${mod}+f" = "fullscreen";

      # Toggle floating window
      "${mod}+Shift+space" = "floating toggle";
      # Swap focus between floating and tiled area
      "${mod}+space" = "focus mode_toggle";

      # Focus on the parent container
      "${mod}+a" = "focus parent";

      ## Scratchpad
      # Sway has a "scratchpad", which is a bag of holding for windows.
      # You can send windows there and get them back later.

      # Move the currently focused window to the scratchpad
      "${mod}+Shift+minus" = "move scratchpad";

      # Show the next scratchpad window or hide the focused scratchpad
      # window.
      # If there are multiple scratchpad windows, this command cycles through
      # them.
      "$mod+minus" = "scratchpad show";

      # Change to resize mode
      "$mod+r" = "mode 'resize'";

      # Switch workspace
      "${mod}+Ctrl+${left}" = "workspace prev";
      "${mod}+Ctrl+${right}" = "workspace next}";
    };

    modes = {
      floating = {
        modifier = mod;
      };

      # Resizing containers:
      resize = {
        keybindings = {
          # left will shrink the containers width
          # right will grow the containers width
          # up will shrink the containers height
          # down will grow the containers height
          "${left}" = "resize shrink width 10px";
          "${down}" = "resize grow height 10px";
          "${up}" = "resize shrink height 10px";
          "${right}" = "resize grow width 10px";

          # Ditto, with arrow keys
          "Left" = "resize shrink width 10px";
          "Down" = "resize grow height 10px";
          "Up" = "resize shrink height 10px";
          "Right" = "resize grow width 10px";

          # Return to default mode
          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      # TODO: figure out the screenshoting
      screenshot = {
        selected = 1;
        whole = 2;
        selected-clipboard = 3;
        whole-clipboard = 4;
        swappy = 5;

        keybindings = {};
      };
    };

    # Status bar
    # Set to empty to use the swaybar
    bars = [];

    ### My configs

    # Styling
    window = {
      border = border_size;
    };
    gaps = {
      inner = gap_size;
      outer = gap_size;
    };
    fonts = [
      font
    ];

    # TODO: figure out the colors
    # Audio
    # TODO: figure out the audio
    # Brightness
    # TODO: figure out the audio
  };

  programs = {
    # Lock the computer
    swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        bs-hl-color = "f5e0dc";
        caps-lock-bs-hl-color = "f5e0dc";
        caps-lock-key-hl-color = "a6e3a1";
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "a6e3a1";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cdd6f4";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-color = "b4befe";
        ring-clear-color = "f5e0dc";
        ring-caps-lock-color = "fab387";
        ring-ver-color = "89b4fa";
        ring-wrong-color = "eba0ac";
        separator-color = "00000000";
        text-color = "cdd6f4";
        text-clear-color = "f5e0dc";
        text-caps-lock-color = "fab387";
        text-ver-color = "89b4fa";
        text-wrong-color = "eba0ac";
      };
    };

    # Application launcher
    fuzzel = {
      enable = true;
      settings = {
        colors = {
          background = "1e1e2edd";
          text = "cdd6f4ff";
          match = "89b4faff";
          selection = "585b70ff";
          selection-match = "89b4faff";
          selection-text = "cdd6f4ff";
          border = "b4befeff";
        };
      };
    };
  };
  services = {
    # Idle Manager
    swayidle = {
      enable = true;
      # This will lock your screen after 300 seconds of inactivity, then
      # turn off your displays after another 300 seconds, and turn your
      # screens back on when resumed. It will also lock your screen before
      # your computer goes to sleep.
      timeouts = [
        {
          timeout = 300;
          command = "swaylock -f -c 000000";
        }
        {
          timeout = 600;
          command = "swaymsg 'output * dpms off'";
        }
      ];
      events = [
        {
          event = "after-resume";
          command = "swaymsg 'output * dpms on'";
        }
        {
          event = "before-sleep";
          command = "swaylock -f -c 000000";
        }
      ];
    };
  };
}
