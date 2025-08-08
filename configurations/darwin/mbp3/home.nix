{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/gui"

        inputs.mac-app-util.homeManagerModules.default
      ];

      custom.home = {
        cli = {
          bat.enable = true; # better cat
          btop.enable = true; # system monitor
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
              # WARNING: overriden by stylix
              # "editor.fontSize" = 13;
            };
          };
          zed.enable = true;
        };
      };
      home.packages =
        let
          # configure nixvim here!
          nixvim = inputs.nixvim-config.packages.${system}.default.extend {
            config.plugins.obsidian = {
              package = pkgs.unstable.vimPlugins.obsidian-nvim;
              settings = {
                legacy_commands = false;
              };
            };

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
                  leetcode.enable = true;
                  obsidian = {
                    enable = true;
                    workspaces = [
                      {
                        name = "personal";
                        path = "/Users/justinhoang/Documents/vaults/personal";
                      }
                      {
                        name = "productivity";
                        path = "/Users/justinhoang/Documents/vaults/productivity";
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
        [
          nixvim
        ];
      # NOTE: darwin module provides the home manager module
      # add under each user rather than global under stylix.nix
      stylix.targets = {
        firefox = {
          enable = true;
          colorTheme.enable = true;
          profileNames = [
            "personal"
            "productivity"
          ];
        };

        vscode = {
          enable = true;
          profileNames = [
            "default"
            "data-science"
            "flutter-development"
            "maximal"
            "web-development"
          ];
        };
      };
    };
  };
}
