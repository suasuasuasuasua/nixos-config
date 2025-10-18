{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.plugins = {
      neorg.settings.load."core.dirman".config = {
        workspaces = {
          "personal" = "/home/justinhoang/Documents/vaults/personal";
          "productivity" = "/home/justinhoang/Documents/vaults/productivity";
        };
        default_workspace = "personal";
      };
      obsidian = {
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
{
  home.packages = [
    nixvim
  ];
}
