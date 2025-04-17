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
    enable = lib.mkEnableOption ''
      GitHub CLI tool
    '';
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;
      extensions = [ ];

      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };
  };
}
