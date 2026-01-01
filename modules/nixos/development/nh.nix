{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.custom.nixos.development.nh;
in
{
  options.custom.nixos.development.nh = {
    inherit (options.programs.nh) flake;

    enable = lib.mkEnableOption ''
      Yet another nix cli helper
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      inherit (cfg) flake;

      enable = true;
    };
  };
}
