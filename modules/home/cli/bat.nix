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
    enable = lib.mkEnableOption ''
      Cat(1) clone with syntax highlighting and Git integration
    '';
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
