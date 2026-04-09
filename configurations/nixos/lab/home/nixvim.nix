{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.plugins = {
      neorg.settings.load."core.dirman".config = {
        workspaces = {
          "default" = "/zshare/personal/notes";
        };
        default_workspace = "default";
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
    };
  };
in
{
  home.packages = [
    nixvim
  ];
}
