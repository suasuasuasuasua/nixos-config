{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.plugins = {
      neorg.settings.load."core.dirman".config = {
        workspaces = {
          "default" = "${config.xdg.userDirs.documents}/vaults";
        };
        default_workspace = "default";
      };
      obsidian = {
        settings = {
          legacy_commands = false;
          workspaces = [
            {
              name = "personal";
              path = "${config.xdg.userDirs.documents}/vaults/personal";
            }
            {
              name = "productivity";
              path = "${config.xdg.userDirs.documents}/vaults/productivity";
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
  };
in
{
  home.packages = [ nixvim ];
}
