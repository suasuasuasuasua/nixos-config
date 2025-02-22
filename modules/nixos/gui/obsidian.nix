{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.obsidian;
in
{
  options.nixos.gui.obsidian = {
    enable = lib.mkEnableOption "Enable Obsidian";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
