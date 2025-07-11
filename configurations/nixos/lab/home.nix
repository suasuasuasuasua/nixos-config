{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  home-manager.users = {
    "justinhoang" = {
      imports = [
        # import the modules
        "${inputs.self}/modules/home/cli"
      ];

      custom.home = {
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
      };
      home.packages =
        let
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
        [ nixvim ];
    };
  };
}
