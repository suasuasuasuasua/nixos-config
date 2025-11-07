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
        cmake.enable = true;
        cssls.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        gopls.enable = true;
        html.enable = true;
        vtsls.enable = true;
      };
      plugins.custom = {
        auto-dark-mode.enable = true;
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
