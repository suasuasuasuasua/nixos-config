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
          "personal" = "${config.xdg.userDirs.documents}/vaults/personal";
          "productivity" = "${config.xdg.userDirs.documents}/vaults/productivity";
        };
        default_workspace = "personal";
      };
      ollama.model = "gemma3";
      obsidian = {
        package = pkgs.unstable.vimPlugins.obsidian-nvim;
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

    config.nixvim = {
      lsp.languages = {
        cssls.enable = true;
        html.enable = true;
        gopls.enable = true;
        vtsls.enable = true;
      };
      plugins.custom = {
        leetcode.enable = true;
        neorg.enable = true;
        obsidian.enable = true;
        ollama.enable = true;
      };
    };
  };
in
{
  home.packages = [
    nixvim
  ];
}
