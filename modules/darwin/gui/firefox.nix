{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.firefox;
in
{
  options.darwin.gui.firefox = {
    enable = lib.mkEnableOption "Enable Firefox";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
