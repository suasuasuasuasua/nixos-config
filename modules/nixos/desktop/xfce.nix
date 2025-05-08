{
  lib,
  config,
  ...
}:
let
  cfg = config.nixos.desktop.xfce;
in
{
  options.nixos.desktop.xfce = {
    enable = lib.mkEnableOption "Enable xfce desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;

        desktopManager = {
          xfce.enable = true;
          xterm.enable = true;
        };
      };

      displayManager.defaultSession = "xfce";
    };
  };
}
