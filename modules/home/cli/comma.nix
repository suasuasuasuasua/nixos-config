{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.home.cli.comma;
in
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.custom.home.cli.comma = {
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
