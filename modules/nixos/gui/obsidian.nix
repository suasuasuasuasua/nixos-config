{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.gui.obsidian;
in
{
  options.gui.obsidian = {
    enable = lib.mkEnableOption "Enable Obsidian";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
