# Packages related to development
{
  flake,
  config,
  lib,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.development.comma;
in
{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.home.development.comma = {
    enable = lib.mkEnableOption "Enable comma";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index-database = {
      comma.enable = true; # runs programs without installing them
    };
  };
}
