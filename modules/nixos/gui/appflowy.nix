{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.appflowy;
in
{
  options.nixos.gui.appflowy = {
    enable = lib.mkEnableOption ''
      An open-source alternative to Notion
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      appflowy
    ];
  };
}
