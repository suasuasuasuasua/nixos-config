{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # configure nixvim here!
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.nixvim = {
      enable = true;
      lsp = {
        bashls.enable = false;
        jsonls.enable = false;
        just.enable = false;
        nil_ls.enable = false;
        nixd.enable = false;
        pyright.enable = false;
        tinymist.enable = false;
      };
      plugins = {
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
          ];
        };
        schemastore.enable = false;
        typst.enable = false;
      };
    };
  };
in
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        "${inputs.self}/modules/home/cli"
        "${inputs.self}/modules/home/gui"
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
          zsh.enable = true;
        };

        gui = {
          alacritty.enable = true;
          firefox.enable = true;
          spotify.enable = true;
        };

        packages = [ nixvim ];
      };
    };
  };
}
