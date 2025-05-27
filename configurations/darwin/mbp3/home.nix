{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # configure nixvim here!
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.nixvim = {
      lsp = {
        languages = {
          cssls.enable = true;
          html.enable = true;
          vtsls.enable = true;
        };
      };
      plugins = {
        custom = {
          obsidian = {
            enable = true;
            workspaces = [
              {
                name = "personal";
                path = "/Users/justinhoang/Documents/vaults/personal";
              }
            ];
          };
          ollama = {
            enable = true;
            model = "gemma3";
          };
        };
      };
    };
  };
in
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import modules
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/gui"

        inputs.mac-app-util.homeManagerModules.default
      ];

      home = {
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
          zsh.enable = true; # preferred shell
        };

        gui = {
          alacritty.enable = true; # terminal emulator
          firefox.enable = true; # browser
          spotify.enable = true; # music platform
          vscode = {
            enable = true;
            package = pkgs.unstable.vscode;
            profiles = {
              data-science.enable = true;
              flutter-development.enable = true;
              maximal.enable = true;
              web-development.enable = true;
            };
            extensions = with pkgs.vscode-extensions; [
              github.copilot
              github.copilot-chat
            ];
            userSettings = {
              "chat.agent.enabled" = true;
              "editor.fontSize" = 13;
            };
          };
        };

        # custom nixvim configuration
        packages = [
          nixvim
        ];
      };
    };
  };
}
