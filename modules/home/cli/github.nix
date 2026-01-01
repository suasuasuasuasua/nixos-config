{ config, lib, ... }:
let
  cfg = config.custom.home.cli.github;
in
{
  options.custom.home.cli.github = {
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
