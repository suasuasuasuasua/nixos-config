{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
inputs.nixvim-config.packages.${system}.default.extend {
  config.plugins = {
    grug-far.package = pkgs.unstable.vimPlugins.grug-far-nvim;
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
    leetcode.enable = true;
    neorg.enable = true;
    obsidian.enable = true;
  };
}
