{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # configure nixvim here!
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.nixvim = {
      lsp = { };
      plugins = {
        custom = {
          auto-dark-mode.enable = false;
          img-clip.enable = false;
          markdown-preview.enable = false;
          obsidian = {
            enable = true;
            workspaces = [
              {
                name = "personal";
                path = "/home/justinhoang/Documents/vaults/personal";
              }
            ];
          };
          remote-nvim.enable = false;
        };
      };
    };
  };
in
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

        packages = [ nixvim ];
      };

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
