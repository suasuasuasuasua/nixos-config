{ inputs, pkgs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/development"
        "${inputs.self}/modules/home/gui"
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
            lsp = { };
            plugins = {
              obsidian.enable = false;
            };
          };
        };

        gui = {
          alacritty.enable = true;
          firefox.enable = true;
          freetube.enable = true;
          obs.enable = true;
          spotify.enable = true;
          vscode = {
            enable = true;
            # package = pkgs.vscodium-fhs;
            package = pkgs.vscode-fhs;
            profiles = {
              data-science.enable = true;
              maximal.enable = true;
            };
          };
        };
      };
    };
  };
}
