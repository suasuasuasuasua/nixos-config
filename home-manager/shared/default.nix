{ user, ...}:
{
  home = {
    username = "${user.name}";
    homeDirectory = "${user.home}";
  };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
