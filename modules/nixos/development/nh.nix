{ config, lib, ... }:
let
  cfg = config.nixos.development.nh;
in
{
  options.nixos.development.nh = {
    enable = lib.mkEnableOption ''
      Yet another nix cli helper
    '';
    # TODO: modularize flake path in a better way
    flake = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      inherit (cfg) flake;

      enable = true;
    };
  };
}
