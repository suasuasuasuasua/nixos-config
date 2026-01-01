{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.cli.devenv;
in
{
  options.custom.home.cli.devenv = {
    enable = lib.mkEnableOption ''
      Fast, Declarative, Reproducible, and Composable Developer Environments
    '';
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv
    ];
  };
}
