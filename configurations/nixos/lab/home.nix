{ inputs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
      ];

      home = {
        cli = {
          bat.enable = true;
          comma.enable = true;
          devenv.enable = true;
          direnv.enable = true;
          fzf.enable = true;
          git.enable = true;
          github.enable = true;
          gnupg.enable = true;
          tmux.enable = true;
          zsh.enable = true;
        };
      };
    };
  };
}
