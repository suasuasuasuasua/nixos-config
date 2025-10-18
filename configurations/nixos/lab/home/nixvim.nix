{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.plugins = {
      grug-far.package = pkgs.unstable.vimPlugins.grug-far-nvim;
      neorg.settings.load."core.dirman".config = {
        workspaces = {
          "personal" = "/zshare/personal/notes/personal";
          "productivity" = "/zshare/personal/notes/productivity";
        };
        default_workspace = "personal";
      };
      obsidian = {
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
{
  home.packages = [
    nixvim
  ];
}
