{user, ...}: {
  programs.git = {
    enable = true;
    userEmail = "${user.email}";
    userName = "${user.fullName}";
    lfs.enable = true;
    extraConfig = {
      core.pager = "diff-so-fancy | less --tabs=4 -RFX";
      interactive.diffFilter = "diff-so-fancy --patch";
    };
  };
}
