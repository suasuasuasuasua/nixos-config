{ inputs, pkgs, ... }:
{
  home-manager.users.justinhoang = {
    imports = [
      inputs.self.homeManagerModules.cli
      inputs.self.homeManagerModules.gui

      ./nvim.nix
    ];

    custom.home = {
      cli = {
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
      gui = {
        alacritty.enable = true;
        firefox.enable = true;
      };
    };

    home.stateVersion = "25.11";
    home.packages = [ pkgs.devenv ];

    stylix.targets = {
      qt.enable = false;
      firefox = {
        enable = true;
        colorTheme.enable = true;
        profileNames = [
          "personal"
          "productivity"
        ];
      };
    };
  };
}
