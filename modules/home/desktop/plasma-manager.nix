{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.desktop.plasma-manager;
in
{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  options.home.desktop.plasma-manager = {
    enable = lib.mkEnableOption ''
      Manage KDE Plasma with Home Manager
    '';

    # TODO: how to add other settings?
    # Use the following command to discover current settings
    # nix run github:nix-community/plasma-manager
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/nix-community/plasma-manager
    # https://nix-community.github.io/plasma-manager/options.xhtml
    # https://github.com/nix-community/plasma-manager/blob/trunk/examples/home.nix
    programs.plasma = {
      enable = true;

      #
      # Some high-level settings:
      #
      workspace = {
        clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
        lookAndFeel = "org.kde.breezedark.desktop";
        cursor = {
          theme = "breeze";
          size = 24;
        };
        iconTheme = "breeze-dark";
        # Milky way is goated
        wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Path/contents/images/2560x1600.jpg";
        # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/MilkyWay/contents/images/5120x2880.png";
      };

      hotkeys.commands."launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Alt+K";
        command = "konsole";
      };

      # Add any widgets
      desktop.widgets = [ ];

      panels = [
        # Windows-like panel at the bottom
        {
          location = "bottom";
          # NOTE: prefer verbose widget name
          # if no configuration is needed, then specify the name only
          widgets = [
            {
              name = "org.kde.plasma.kickoff";
              config = {
                General = {
                  icon = "nix-snowflake-white";
                  alphaSort = true;
                };
              };
            }
            "org.kde.plasma.marginsseparator"
            {
              name = "org.kde.plasma.icontasks";
              config = {
                General = {
                  launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:org.kde.konsole.desktop"
                    "applications:org.kde.kate.desktop"
                    "applications:code.desktop"
                    "applications:firefox.desktop"
                    "applications:spotify.desktop"
                  ];
                };
              };
            }
            "org.kde.plasma.marginsseparator"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
            "org.kde.plasma.showdesktop"
          ];
          # hiding = "autohide";
        }
        # Application name, Global menu and Song information and playback controls at the top
        {
          location = "top";
          height = 26;
          widgets = [
            {
              applicationTitleBar = {
                behavior = {
                  activeTaskSource = "activeTask";
                };
                layout = {
                  elements = [ "windowTitle" ];
                  horizontalAlignment = "left";
                  showDisabledElements = "deactivated";
                  verticalAlignment = "center";
                };
                overrideForMaximized.enable = false;
                titleReplacements = [
                  {
                    type = "regexp";
                    originalTitle = ''\\bDolphin\\b'';
                    newTitle = "File manager";
                  }
                ];
                windowTitle = {
                  font = {
                    bold = false;
                    fit = "fixedSize";
                    size = 12;
                  };
                  hideEmptyTitle = true;
                  margins = {
                    bottom = 0;
                    left = 10;
                    right = 5;
                    top = 0;
                  };
                  source = "appName";
                };
              };
            }
            "org.kde.plasma.appmenu"
            "org.kde.plasma.panelspacer"
            {
              plasmusicToolbar = {
                panelIcon = {
                  albumCover = {
                    useAsIcon = false;
                    radius = 8;
                  };
                  icon = "view-media-track";
                };
                playbackSource = "auto";
                musicControls.showPlaybackControls = true;
                songText = {
                  displayInSeparateLines = true;
                  maximumWidth = 640;
                  scrolling = {
                    behavior = "alwaysScroll";
                    speed = 3;
                  };
                };
              };
            }
          ];
        }
      ];

      window-rules = [
        {
          description = "Dolphin";
          match = {
            window-class = {
              value = "dolphin";
              type = "substring";
            };
            window-types = [ "normal" ];
          };
          apply = {
            noborder = {
              value = true;
              apply = "force";
            };
            # `apply` defaults to "apply-initially"
            maximizehoriz = true;
            maximizevert = true;
          };
        }
      ];

      powerdevil = {
        AC = {
          autoSuspend = {
            action = "sleep";
            idleTimeout = 1200; # 20 minutes
          };
          turnOffDisplay = {
            idleTimeout = 600; # 10 minutes
            idleTimeoutWhenLocked = "immediately";
          };
          powerButtonAction = "lockScreen";
          powerProfile = "performance";
        };
        battery = {
          whenSleepingEnter = "standbyThenHibernate";
          powerButtonAction = "sleep";
          powerProfile = "balanced";
        };
        lowBattery = {
          displayBrightness = 30;
          whenLaptopLidClosed = "hibernate";
          powerProfile = "powerSaving";
        };

        batteryLevels = {
          lowLevel = 20;
          criticalLevel = 5;
          criticalAction = "hibernate";
        };

        general = {
          pausePlayersOnSuspend = true;
        };
      };

      kwin = {
        edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
        cornerBarrier = false;

        scripts.polonium = {
          enable = false;
          settings = {
            layout.engine = "binaryTree";
          };
        };
      };

      kscreenlocker = {
        lockOnResume = true;
        timeout = 10;
      };

      #
      # Some mid-level settings:
      #
      shortcuts = {
        ksmserver = {
          "Lock Session" = [
            "Screensaver"
            "Meta+Ctrl+Alt+L"
          ];
        };

        kwin = {
          "Expose" = "Meta+,";
          "Switch Window Down" = "Meta+J";
          "Switch Window Left" = "Meta+H";
          "Switch Window Right" = "Meta+L";
          "Switch Window Up" = "Meta+K";
        };
      };

      #
      # Some low-level settings:
      #
      configFile = {
        baloofilerc."Basic Settings"."Indexing-Enabled" = false;
        kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
        kscreenlockerrc = {
          Greeter.WallpaperPlugin = "org.kde.potd";
          # To use nested groups use / as a separator. In the below example,
          # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
          "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
        };
      };
    };
  };
}
