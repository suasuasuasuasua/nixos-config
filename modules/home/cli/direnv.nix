{ config, lib, ... }:
let
  cfg = config.custom.home.cli.direnv;
in
{
  options.custom.home.cli.direnv = {
    enable = lib.mkEnableOption ''
      Shell extension that manages your environment
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true; # faster implementation for nix
      # silent = true; # silent mode so it doesn't flood stdout
    };
  };
}
