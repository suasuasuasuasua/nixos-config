{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
inputs.nixvim-config.packages.${system}.default.extend {
  config.plugins = {
    neorg.settings = {
      workspaces = {
        "personal" = "/Users/justinhoang/Documents/vaults/personal";
        "productivity" = "/Users/justinhoang/Documents/vaults/productivity";
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
            path = "/Users/justinhoang/Documents/vaults/personal";
          }
          {
            name = "productivity";
            path = "/Users/justinhoang/Documents/vaults/productivity";
          }
        ];
      };
    };
  };

  config.nixvim = {
    lsp.languages = {
      cssls.enable = true;
      html.enable = true;
      vtsls.enable = true;
    };
    plugins = {
      custom = {
        leetcode.enable = true;
        neorg.enable = true;
        obsidian.enable = true;
        ollama.enable = true;
      };
    };
  };
}
