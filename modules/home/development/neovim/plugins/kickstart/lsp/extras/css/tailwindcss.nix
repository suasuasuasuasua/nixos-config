{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "tailwindcss";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins = {
      lsp.servers.tailwindcss = {
        enable = true;
        # NOTE: add options as I need
      };

      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        css
      ];
    };
  };
}
