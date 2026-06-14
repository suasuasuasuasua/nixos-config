{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.plugins = {
      neorg.settings.load."core.dirman".config = {
        workspaces.default = "/zshare/personal/notes";
        default_workspace = "default";
      };
      obsidian.settings = {
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
in
{
  home.packages = [ nixvim ];
}
