{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.darwin.utility.iina;
in
{
  options.darwin.utility.iina = {
    enable = lib.mkEnableOption "Enable modern macOS video playback app";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      iina
    ];
  };
}
