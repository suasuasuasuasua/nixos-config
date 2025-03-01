{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.kdenlive;
in
{
  options.darwin.gui.kdenlive = {
    enable = lib.mkEnableOption "Enable Kdenlive video editor";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
    ];
  };
}
