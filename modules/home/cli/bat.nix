{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.cli.bat;
in
{
  options.home.cli.bat = {
    enable = lib.mkEnableOption "Enable bat";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };
  };
}
