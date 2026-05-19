{ inputs, ... }:
{
  home-manager.users.admin = {
    home.stateVersion = "24.11";
    imports = [ inputs.self.homeManagerModules.cli ];

    custom.home.cli = {
      fzf.enable = true;
      git.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
  };
}
