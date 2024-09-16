{user, ...}: {
  programs.git = {
    enable = true;
    userEmail = "${user.email}";
    userName = "${user.fullName}";
    lfs.enable = true;
    # Support packages
    diff-so-fancy.enable = true;
  };
  programs.lazygit = {
    enable = true;
  };
}
