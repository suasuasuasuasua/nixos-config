{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.kdenlive;
in
{
  options.nixos.gui.kdenlive = {
    enable = lib.mkEnableOption "Enable Kdenlive video editor";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
    ];
  };
}
