{ config, lib, ... }:
let
  cfg = config.custom.home.cli.atuin;
in
{
  options.custom.home.cli.atuin = {
    enable = lib.mkEnableOption ''
      Replacement for a shell history which records additional commands context
      with optional encrypted synchronization between machines
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;

      enableZshIntegration = true;
      settings = { };
    };
  };
}
