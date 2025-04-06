{
  lib,
  config,
  ...
}:
let
  cfg = config.home.cli.git;
in
{
  options.home.cli.git = {
    enable = lib.mkEnableOption ''
      Distributed version control system
    '';
    # TODO: add dynamic username, emial, gpg signing, etc.
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userEmail = "j124.dev@proton.me";
      userName = "Justin Hoang";
      lfs.enable = true;

      # Support packages
      diff-so-fancy.enable = true;

      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
      ];

      signing = {
        key = "j124.dev@proton.me";
        signByDefault = true;
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "false";
      };
    };

    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "diff-so-fancy";
          };
        };
        # disable prompt tp return from subprocess
        promptToReturnFromSubprocess = false;
      };
    };
  };
}
