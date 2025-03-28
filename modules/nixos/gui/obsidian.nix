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
    enable = lib.mkEnableOption ''
      Powerful knowledge base that works on top of a local folder of plain text
      Markdown files
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
