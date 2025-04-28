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

      config.home = {
        cli = {
          bat.enable = true; # better cat
          comma.enable = true; # try out programs with `,`
          devenv.enable = true; # easy dev environemnts
          direnv.enable = true; # switch dev environments with .envrc files
          fzf.enable = true; # fuzzy finder
          git.enable = true; # source control
          github.enable = true; # github cli integration
          gnupg.enable = true; # gpg key signing
          tmux.enable = true; # terminal multiplexer
        };
        development = {
          neovim = {
            enable = true;
            lsp = { };
            plugins = {
              leetcode.enable = true;
            };
          };
          zsh.enable = true;
        };
        gui = {
          alacritty.enable = true;
          firefox.enable = true;
          obs.enable = true;
          spotify.enable = true;
          vscode = {
            enable = true;
            package = pkgs.vscodium-fhs;
            profiles = {
              "Data Science".enable = true;
              "Maximal".enable = true;
            };
            userSettings = {
              "editor.fontSize" = 13;
            };
          };
        };
      };
    };
  };
}
