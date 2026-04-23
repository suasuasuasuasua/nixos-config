{ inputs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        "${inputs.self}/modules/home/cli"

        ./nixvim.nix
      ];

      custom.home = {
        cli = {
          bat.enable = true;
          comma.enable = true;
          devenv.enable = true;
          direnv.enable = true;
          fzf.enable = true;
          git.enable = true;
          github.enable = true;
          gnupg.enable = true;
          starship.enable = true;
          tmux.enable = true;
          zsh.enable = true;
        };
      };
    };
  };
}
