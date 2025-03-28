{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.cli.devenv;
in
{
  options.home.cli.devenv = {
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
