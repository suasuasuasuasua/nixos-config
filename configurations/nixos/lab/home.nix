{ inputs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/development"
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

        development = {
          neovim = {
            enable = true;
            colorscheme.enable = false;
            lsp = { };
            plugins = {
              # headless
              auto-dark-mode.enable = false;
              img-clip.enable = false;
              markdown-preview.enable = false;
              remote-nvim.enable = false;
              obsidian.enable = false;
            };
          };
        };
      };
    };
  };
}
