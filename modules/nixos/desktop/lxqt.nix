{
  lib,
  config,
  ...
}:
let
  cfg = config.nixos.desktop.lxqt;
in
{
  options.nixos.desktop.lxqt = {
    enable = lib.mkEnableOption "Enable lxqt desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;

        desktopManager = {
          lxqt.enable = true;
          xterm.enable = true;
        };
      };

      displayManager.defaultSession = "lxqt";
    };
  };
}
