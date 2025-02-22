{ lib, config, ... }:
let
  cfg = config.gui.firefox;
in
{
  options.gui.firefox = {
    enable = lib.mkEnableOption "Enable Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      # TODO: many options for firefox
    };
  };
}
