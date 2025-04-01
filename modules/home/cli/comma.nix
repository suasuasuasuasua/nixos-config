{
  flake,
  config,
  lib,
  ...
}:
let
  inherit (flake) inputs;

  cfg = config.home.cli.comma;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.home.cli.comma = {
    enable = lib.mkEnableOption ''
      Runs programs without installing them
    '';
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
      nix-index-database = {
        comma.enable = true;
      };
    };
  };
}
