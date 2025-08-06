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
          btop.enable = true; # system monitor
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
            config.plugins.obsidian = {
              package = pkgs.unstable.vimPlugins.obsidian-nvim;
              settings = {
                legacy_commands = false;
              };
            };

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
                        path = "/zshare/personal/notes/personal";
                      }
                      {
                        name = "productivity";
                        path = "/zshare/personal/notes/productivity";
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
