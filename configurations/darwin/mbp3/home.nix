{ inputs, pkgs, ... }:
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import modules
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/development"
        "${inputs.self}/modules/home/gui"

        inputs.mac-app-util.homeManagerModules.default
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
            enable = true; # enable nixvim config
            lsp = { };
            plugins = {
              ollama = {
                enable = true;
                model = "gemma3";
              };
            };
          };
          zsh.enable = true; # preferred shell
        };

        gui = {
          alacritty.enable = true; # terminal emulator
          firefox.enable = true; # browser
          spotify.enable = true; # music platform
          vscode = {
            enable = true;
            package = pkgs.vscodium;
            profiles = {
              data-science.enable = true;
              maximal.enable = true;
            };
            extensions = with pkgs.vscode-extensions; [
              continue.continue # run local AIs
            ];
            userSettings = {
              "continue.enableTabAutocomplete" = false;
              "continue.telemetryEnabled" = false;
              "editor.fontSize" = 13;
            };
          };
        };
      };
    };
  };
}
