{ config, lib, ... }:
let
  cfg = config.nixos.development.nh;
in
{
  options.nixos.development.nh = {
    enable = lib.mkEnableOption "Enable nh nix helper";
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/justinhoang/nixos-config/";
    };
  };
}
