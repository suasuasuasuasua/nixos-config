{
  config,
  lib,
  users,
  ...
}:
let
  cfg = config.custom.home.cli.git;
  userInfo = users.${config.home.username};
in
{
  options.custom.home.cli.git = {
    enable = lib.mkEnableOption ''
      Distributed version control system
    '';
  };

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = lib.optionalAttrs (userInfo ? email) {
            inherit (userInfo) email name;
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

        signing = lib.mkIf (userInfo ? email) {
          key = userInfo.email;
          signByDefault = true;
        };
      };
      lazygit = {
        enable = true;
        settings = {
          git = {
            commit.signoff = true;
            overrideGpg = false; # NOTE: saves gpg headaches
            pagers = [
              {
                # side by side view with git-delta
                pager = "delta --dark --paging=never --side-by-side --line-numbers";
                colorArg = "always";
              }
            ];
          };
          # disable prompt to return from subprocess
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
