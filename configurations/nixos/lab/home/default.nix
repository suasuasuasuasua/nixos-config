{ inputs, pkgs, ... }:
{
  home-manager.users.justinhoang = {
    imports = [
      inputs.self.homeManagerModules.cli

      ./nvim.nix
    ];

    custom.home.cli = {
      bat.enable = true;
      btop.enable = true;
      comma.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      ripgrep.enable = true;
      git.enable = true;
      github.enable = true;
      gnupg.enable = true;
      starship.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };

    home.stateVersion = "24.11";
    home.packages = [ pkgs.devenv ];
  };
}
