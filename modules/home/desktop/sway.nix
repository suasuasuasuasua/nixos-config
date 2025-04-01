{
  config,
  lib,
  ...
}:
let
  cfg = config.home.desktop.sway;
in
{
  options.home.desktop.sway = {
    enable = lib.mkEnableOption "Enable sway config";
    # TODO: finish
    output = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf str);
      default = { };
      description = ''
        do `swaymsg -t get_outputs` to find available options
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;

      # validate the config file
      checkConfig = true;
      # config options
      config = rec {
        inherit (cfg) output;

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

        # Disable the bars (using waybar)
        bars = [ ];
      };
    };
  };
}
