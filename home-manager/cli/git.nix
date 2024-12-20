{user, ...}: {
  programs.git = {
    enable = true;
    userEmail = "${user.email}";
    userName = "${user.fullName}";
    lfs.enable = true;

    # Support packages
    diff-so-fancy.enable = true;

    signing = {
      key = "${user.email}";
      signByDefault = true;
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gh = {
    enable = true;

    settings = {
      editor = "nvim";
    };
  };

  # dashboard extension for gh cli
  programs.gh-dash = {
    enable = true;
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
    };
  };

  programs.git-cliff = {
    enable = true;
  };
}
