{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # configure nixvim here!
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.nixvim = {
      enable = true;
      lsp = { };
      colorscheme.enable = false;
      plugins = {
        auto-dark-mode.enable = false;
        img-clip.enable = false;
        markdown-preview.enable = false;
        obsidian.enable = false;
        remote-nvim.enable = false;
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
    };
  };
}
