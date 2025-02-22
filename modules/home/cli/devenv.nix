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
    enable = lib.mkEnableOption "Enable devenv";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    # Add stuff for your user as you see fit:
    home.packages = with pkgs; [
      devenv
    ];
  };
}
