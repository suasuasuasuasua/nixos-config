{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.darwin.gui.obsidian;
in
{
  options.darwin.gui.obsidian = {
    enable = lib.mkEnableOption "Enable Obsidian";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
