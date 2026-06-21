{ config, lib, ... }:
let
  cfg = config.custom.home.cli.ripgrep;
in
{
  options.custom.home.cli.ripgrep = {
    enable = lib.mkEnableOption "ripgrep search tool";
  };

  config = lib.mkIf cfg.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--hidden"
        "--glob=!.git"
        "--smart-case"
      ];
    };
  };
}
