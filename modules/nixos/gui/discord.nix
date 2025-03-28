{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixos.gui.discord;
in
{
  options.nixos.gui.discord = {
    enable = lib.mkEnableOption ''
      All-in-one cross-platform voice and text chat for gamers
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
    ];
  };
}
