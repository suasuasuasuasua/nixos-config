{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "ltex";
  cfg = config.home.development.neovim.lsp.${name};
in
{
  options.home.development.neovim.lsp.${name} = {
    enable = lib.mkEnableOption "Enable ${name} LSP for neovim";
  };

  config = lib.mkIf cfg.enable {

    programs.nixvim = {
      plugins.lsp.servers.ltex = {
        enable = true;
        # NOTE: add options as I need
      };

      # implement code actiosn from lsp specifications
      extraPlugins = with pkgs; [
        vimPlugins.ltex_extra-nvim
      ];

      # https://github.com/barreiroleo/ltex_extra.nvim
      extraConfigLua =
        # lua
        ''
          require("lspconfig").ltex.setup {
            on_attach = function(client, bufnr)
              -- rest of your on_attach process.
              require("ltex_extra").setup { }
            end
          }
        '';
    };
  };
}
