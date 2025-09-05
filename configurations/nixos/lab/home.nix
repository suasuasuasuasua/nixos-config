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
          starship.enable = true;
          tmux.enable = true;
          zsh.enable = true;
        };
      };
      home.packages =
        let
          nixvim = inputs.nixvim-config.packages.${system}.default.extend {
            config.plugins = {
              neorg.settings = {
                workspaces = {
                  "personal" = "/zshare/personal/notes/personal";
                  "productivity" = "/zshare/personal/notes/productivity";
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
                      path = "/zshare/personal/notes/personal";
                    }
                    {
                      name = "productivity";
                      path = "/zshare/personal/notes/productivity";
                    }
                  ];
                };
              };
            };

            config.nixvim.plugins.custom = {
              auto-dark-mode.enable = false;
              img-clip.enable = false;
              leetcode.enable = true;
              markdown-preview.enable = false;
              neorg.enable = true;
              obsidian.enable = true;
              remote-nvim.enable = false;
            };
          };
        in
        [ nixvim ];
    };
  };
}
