{ inputs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/development"
      ];

      config.home = {
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
        };

        development = {
          neovim = {
            enable = true;
            colorscheme.enable = false;
            lsp = { };
            plugins = { };
          };
          zsh.enable = true;
        };
      };
    };
  };
}
