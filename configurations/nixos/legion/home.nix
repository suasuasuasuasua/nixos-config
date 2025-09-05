{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/gui"
      ];

      custom.home = {
        cli = {
          bat.enable = true;
          btop = {
            enable = true; # system monitor
            package = pkgs.btop-cuda;
          };
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
          zed.enable = true;
        };
      };
      home.packages =
        let
          nixvim = inputs.nixvim-config.packages.${system}.default.extend {
            config.plugins = {
              neorg.settings = {
                workspaces = {
                  "personal" = "/home/justinhoang/Documents/vaults/personal";
                  "productivity" = "/home/justinhoang/Documents/vaults/productivity";
                };
                default_workspace = "personal";
              };
              obsidian = {
                package = pkgs.unstable.vimPlugins.obsidian-nvim;
                settings = {
                  legacy_commands = false;
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
              };
            };

            config.nixvim.plugins.custom = {
              grug-far.enable = true;
              neorg.enable = true;
              obsidian.enable = true;
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

        vscode = {
          enable = true;
          profileNames = [
            "default"
            "data-science"
            "maximal"
          ];
        };
      };
    };
  };
}
