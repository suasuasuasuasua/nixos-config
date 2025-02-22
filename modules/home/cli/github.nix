{
  lib,
  config,
  ...
}:
let
  cfg = config.home.cli.github;
in
{
  options.home.cli.github = {
    enable = lib.mkEnableOption "Enable gh (CLI)";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      # TODO: add extensions as necessary
      extensions = [ ];

      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };
  };
}
