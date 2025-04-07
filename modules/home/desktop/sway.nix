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
    # Main sway configuration
    # https://nix-community.github.io/home-manager/options.xhtml#opt-wayland.windowManager.sway.config.defaultWorkspace
    # https://github.com/nix-community/home-manager/blob/release-24.11/modules/services/window-managers/i3-sway/sway.nix
    wayland.windowManager.sway = {
      enable = true;

      # Validate the config file
      checkConfig = true;
      # General config options
      config = rec {
        inherit (cfg) modifier input output;

        # home row direction keys, live vim
        left = "h";
        down = "j";
        up = "k";
        right = "l";

        # start the first workspace to `1`
        defaultWorkspace = "workspace number 1";

        # Preferred terminal emulator
        terminal = "${pkgs.foot}/bin/foot";

        # Your preferred application launcher
        # Note: pass the final command to swaymsg so that the resulting window
        # can be opened on the original workspace that the command was run on.
        menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";

        # i basically use all default config anyway, so don't override default
        # config!
        keybindings = lib.mkOptionDefault {
          # Brightness
          XF86MonBrightnessDown = "exec light -U 10";
          XF86MonBrightnessUp = "exec light -A 10";
          # Volume
          XF86AudioRaiseVolume = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'";
          XF86AudioLowerVolume = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'";
          XF86AudioMute = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
        };

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

        # Gaps between the windows!
        gaps = {
          inner = 3;
          outer = 3;
          smartBorders = "on";
          smartGaps = true;
        };
      };

      extraConfig = lib.mkDefault ''
        # TODO: modularize this or find the _actual_ setting
        # Enable and disable the laptop display in clamshell mode
        bindswitch --reload --locked lid:on output eDP-1 disable
        bindswitch --reload --locked lid:off output eDP-1 enable
      '';
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
          timeout = 300; # 5 minutes - lock
          command = "${pkgs.swaylock}/bin/swaylock -fF -c 000000";
        }
        {
          timeout = 600; # 10 minutes - suspend
          command = "${pkgs.systemd}/bin/systemctl suspend";
          # command = "${pkgs.swaymsg}/bin/swaymsg output * dpms off";
        }
      ];
    };

    # prettier status bar
    programs.waybar = {
      enable = true;
      # https://github.com/Alexays/Waybar/wiki/Configuration
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          # Waybar height
          height = 30;
          # Gaps between modules (in pixels)
          spacing = 4;

          keyboard-state = {
            numlock = true;
            capslock = true;
            format = "{name} {icon}";
            format-icons = {
              "locked" = "";
              "unlocked" = "";
            };
          };

          modules-left = [
            "sway/workspaces"
            "sway/mode"
            "sway/scratchpad"
          ];
          modules-center = [
            "sway/window"
          ];
          modules-right = [
            "mpd"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "keyboard-state"
            "sway/language"
            "battery"
            "battery#bat2"
            "clock"
            "tray"
            "custom/power"
          ];

          "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
          };
          "sway/scratchpad" = {
            "format" = "{icon} {count}";
            "show-empty" = false;
            "format-icons" = [
              ""
              ""
            ];
            "tooltip" = true;
            "tooltip-format" = "{app}: {title}";
          };

          "mpd" = {
            "format" = ''
              {stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% 
            '';
            "format-disconnected" = "Disconnected ";
            "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            "unknown-tag" = "N/A";
            "interval" = 5;
            "consume-icons" = {
              "on" = " ";
            };
            "random-icons" = {
              "off" = "<span color=\"#f53c3c\"></span> ";
              "on" = " ";
            };
            "repeat-icons" = {
              "on" = " ";
            };
            "single-icons" = {
              "on" = "1 ";
            };
            "state-icons" = {
              "paused" = "";
              "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
          };
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "";
              "deactivated" = "";
            };
          };
          "tray" = {
            # // "icon-size": 21,
            "spacing" = 10;
            # // "icons": {
            # //   "blueman": "bluetooth",
            # //   "TelegramDesktop": "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png"
            # // }
          };
          "clock" = {
            "timezone" = "America/Denver";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%Y-%m-%d}";
          };
          "cpu" = {
            "format" = "{usage}% ";
            "tooltip" = false;
          };
          "memory" = {
            "format" = "{}% ";
          };
          "temperature" = {
            # "thermal-zone": 2,
            # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
            "critical-threshold" = 80;
            # "format-critical": "{temperatureC}°C {icon}",
            "format" = "{temperatureC}°C {icon}";
            "format-icons" = [
              ""
              ""
              ""
            ];
          };
          "backlight" = {
            # "device": "acpi_video1",
            "format" = "{percent}% {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "battery" = {
            "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-full" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            # // "format-good": "", // An empty format will hide the module
            # // "format-full": "",
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "battery#bat2" = {
            "bat" = "BAT2";
          };
          "power-profiles-daemon" = {
            "format" = "{icon}";
            "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
            "tooltip" = true;
            "format-icons" = {
              "default" = "";
              "performance" = "";
              "balanced" = "";
              "power-saver" = "";
            };
          };
          "network" = {
            # // "interface": "wlp2*", // (Optional) To force the use of this interface
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr}/{cidr} ";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected ⚠";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          };
          # TODO: migrate to pipewire
          "pulseaudio" = {
            "scroll-step" = 1; # %, can be a float
            "format" = "{volume}% {icon} {format_source}";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                ""
                ""
                ""
              ];
            };
            "on-click" = "pavucontrol";
          };
          "custom/media" = {
            "format" = "{icon} {text}";
            "return-type" = "json";
            "max-length" = 40;
            "format-icons" = {
              "spotify" = "";
              "default" = "🎜";
            };
            "escape" = true;
            "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # Script in resources folder
            # // "exec": "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
          };
          "custom/power" = {
            "format" = "⏻ ";
            "tooltip" = false;
            "menu" = "on-click";
            "menu-file" = "$HOME/.config/waybar/power_menu.xml"; # // Menu file in resources folder
            "menu-actions" = {
              "shutdown" = "shutdown";
              "reboot" = "reboot";
              "suspend" = "systemctl suspend";
              "hibernate" = "systemctl hibernate";
            };
          };
          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };
        };
      };
      style =
        # css
        ''
          /* * { */
          /*   border: none; */
          /*   border-radius: 0; */
          /*   font-family: Source Code Pro; */
          /* } */
          window#waybar {
            background: #16191C;
            color: #AAB2BF;
          }
          #workspaces button {
            padding: 0 5px;
          }
        '';
    };
  };
}
