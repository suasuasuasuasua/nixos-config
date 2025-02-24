{
  lib,
  config,
  ...
}:
let
  cfg = config.home.cli.direnv;
in
{
  options.home.cli.direnv = {
    enable = lib.mkEnableOption "Enable direnv";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
