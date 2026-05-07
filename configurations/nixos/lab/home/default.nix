{ inputs, pkgs, ... }:
{
  home-manager.users.justinhoang = {
    imports = [
      inputs.self.homeManagerModules.cli

      ./nixvim.nix
    ];

    custom.home.cli = {
      bat.enable = true;
      btop.enable = true; # system monitor
      comma.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      github.enable = true;
      gnupg.enable = true;
      starship.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };

    home.packages = [ pkgs.devenv ];
  };
}
