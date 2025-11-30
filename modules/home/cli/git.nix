{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.home.cli.git;
in
{
  options.custom.home.cli.git = {
    enable = lib.mkEnableOption ''
      Distributed version control system
    '';
    # TODO: add dynamic username, email, gpg signing, etc.
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            email = "j124.dev@proton.me";
            name = "Justin Hoang";
          };
          init.defaultBranch = "main";
          pull.rebase = "false";
          push.autoSetupRemote = true;
        };

        lfs.enable = true;

        ignores = [
          "*~"
          "*.swp"
          ".DS_Store"
        ];

        signing = {
          key = "j124.dev@proton.me";
          signByDefault = true;
        };
      };
      lazygit = {
        enable = true;
        settings = {
          git = {
            commit = {
              signoff = true;
            };
            overrideGpg = true;
            pagers = [
              {
                # side by side view with git-delta
                pager = "delta --dark --paging=never --side-by-side --line-numbers";
                colorArg = "always";
              }
            ];
          };
          # disable prompt tp return from subprocess
          promptToReturnFromSubprocess = false;
        };
      };

      delta = {
        enable = true;
        enableGitIntegration = true;
      };
    };

  };
}
