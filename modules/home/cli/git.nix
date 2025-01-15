{
  programs.git = {
    enable = true;
    userEmail = "j124.dev@proton.me";
    userName = "Justin Hoang";
    lfs.enable = true;

    # Support packages
    diff-so-fancy.enable = true;

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
    };
  };
}
