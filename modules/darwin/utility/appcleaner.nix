{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.darwin.utility.appcleaner;
in
{
  options.darwin.utility.appcleaner = {
    enable = lib.mkEnableOption "Enable an app cleaner support app";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      appcleaner
    ];
  };
}
