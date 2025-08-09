{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

in
# configure nixvim here!
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/gui"
      ];

      custom.home = {
        cli = {
          atuin.enable = true;
          bat.enable = true; # better cat
          btop.enable = true; # system monitor
          comma.enable = true; # try out programs with `,`
          devenv.enable = true; # easy dev environemnts
          direnv.enable = true; # switch dev environments with .envrc files
          fzf.enable = true; # fuzzy finder
          git.enable = true; # source control
          github.enable = true; # github cli integration
          gnupg.enable = true; # gpg key signing
          starship.enable = true;
          tmux.enable = true; # terminal multiplexer
          zsh.enable = true;
        };
        gui = {
          firefox.enable = true;
          obs.enable = true;
          spotify.enable = true;
          zed.enable = true;
        };
      };
      home.packages =
        let
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
                  bashls.enable = false;
                  jsonls.enable = false;
                  just.enable = false;
                  nil_ls.enable = false;
                  nixd.enable = false;
                  pyright.enable = false;
                  tinymist.enable = false;
                };
              };
              plugins = {
                custom = {
                  auto-dark-mode.enable = false;
                  diffview.enable = false;
                  img-clip.enable = false;
                  obsidian = {
                    enable = true;
                    workspaces = [
                      {
                        name = "personal";
                        path = "/home/justinhoang/Documents/vaults/personal";
                      }
                      {
                        name = "productivity";
                        path = "/home/justinhoang/Documents/vaults/productivity";
                      }
                    ];
                  };
                  schemastore.enable = false;
                  typst.enable = false;
                };
              };
            };
          };
        in
        [ nixvim ];
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
      };
    };
  };
}
