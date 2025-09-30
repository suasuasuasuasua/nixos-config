{
  services.aerospace = {
    enable = true;

    settings = {
      gaps =
        let
          gap = 4;
        in
        {
          inner = {
            horizontal = gap;
            vertical = gap;
          };
          outer = {
            left = gap;
            bottom = gap;
            top = gap;
            right = gap;
          };
        };
      # let launchd be responsible
      start-at-login = false;
      # force monitor arrangements
      # let the macbook built in handle 1-5, then the secondary display handle
      # 6-0
      workspace-to-monitor-force-assignment = {
        "1" = "Built-in Retina Display";
        "2" = "Built-in Retina Display";
        "3" = "Built-in Retina Display";
        "4" = "Built-in Retina Display";
        "5" = "Built-in Retina Display";
        "6" = "S27C900P";
        "7" = "S27C900P";
        "8" = "S27C900P";
        "9" = "S27C900P";
        "0" = "S27C900P";
      };
      after-startup-command = [
        "workspace 6"
        "move-workspace-to-monitor --wrap-around next"
        "workspace 1"
      ];
      mode.main.binding = {
        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";
        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # https://nikitabobko.github.io/AeroSpace/goodies#i3-like-config
        alt-f = "fullscreen";
        alt-s = "layout v_accordion"; # 'layout stacking' in i3
        alt-w = "layout h_accordion"; # 'layout tabbed' in i3
        alt-e = "layout tiles horizontal vertical"; # 'layout toggle split' in i3
        alt-shift-space = "layout floating tiling"; # 'floating toggle' in i3

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";
        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        # alt-a = "workspace A";
        # alt-b = "workspace B";
        # alt-c = "workspace C";
        # alt-d = "workspace D";
        # alt-e = "workspace E";
        # alt-f = "workspace F";
        # alt-g = "workspace G";
        # alt-i = "workspace I";
        # alt-m = "workspace M";
        # alt-n = "workspace N";
        # alt-o = "workspace O";
        # alt-p = "workspace P";
        # alt-q = "workspace Q";
        # alt-r = "workspace R";
        # alt-s = "workspace S";
        # amands#move-node-to-workspace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        # alt-shift-a = "move-node-to-workspace A";
        # alt-shift-b = "move-node-to-workspace B";
        # alt-shift-c = "move-node-to-workspace C";
        # alt-shift-d = "move-node-to-workspace D";
        # alt-shift-e = "move-node-to-workspace E";
        # alt-shift-f = "move-node-to-workspace F";
        # alt-shift-g = "move-node-to-workspace G";
        # alt-shift-i = "move-node-to-workspace I";
        # alt-shift-m = "move-node-to-workspace M";
        # alt-shift-n = "move-node-to-workspace N";
        # alt-shift-o = "move-node-to-workspace O";
        # alt-shift-p = "move-node-to-workspace P";
        # alt-shift-q = "move-node-to-workspace Q";
        # alt-shift-r = "move-node-to-workspace R";
        # alt-shift-s = "move-node-to-workspace S";
        # alt-shift-t = "move-node-to-workspace T";
        # alt-shift-u = "move-node-to-workspace U";
        # alt-shift-v = "move-node-to-workspace V";
        # alt-shift-w = "move-node-to-workspace W";
        # alt-shift-x = "move-node-to-workspace X";
        # alt-shift-y = "move-node-to-workspace Y";
        # alt-shift-z = "move-node-to-workspace Z";
        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-shift-semicolon = "mode service";
      };
      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ]; # reset layout
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        #s = ['layout sticky tiling', 'mode main']
        alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        alt-shift-l = [
          "join-with right"
          "mode main"
        ];

        down = "volume down";
        up = "volume up";
        shift-down = [
          "volume set 0"
          "mode main"
        ];
      };
    };
  };
}
