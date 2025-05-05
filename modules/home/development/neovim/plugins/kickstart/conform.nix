{ pkgs, ... }:
{
  programs.nixvim = {
    # Autoformat
    # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notifyOnError = false;
        format_on_save =
          # lua
          ''
            function(bufnr)
              -- Disable "format_on_save lsp_fallback" for lanuages that don't
              -- have a well standardized coding style. You can add additional
              -- lanuages here or re-enable it for the disabled ones.
              local disable_filetypes = { c = true, cpp = true }
              if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
              else
                return { timeout_ms = 500, lsp_format = 'fallback', }
              end
            end
          '';
        formattersByFt = {
          lua = [ "stylua" ];
          # Conform can also run multiple formatters sequentially
          # python = [ "isort "black" ];
          #
          # You can use a sublist to tell conform to run *until* a formatter
          # is found
          # javascript = [ [ "prettierd" "prettier" ] ];
        };
      };

      lazyLoad = {
        enable = true;
        settings = {
          event = [ "BufWritePre" ];
          cmd = [ "ConformInfo" ];
        };
      };
    };

    # Dependencies
    #
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages
    extraPackages = with pkgs; [
      # Used to format Lua code
      stylua
    ];

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        mode = "";
        key = "<leader>f";
        action.__raw =
          # lua
          ''
            function()
              require('conform').format { async = true, lsp_fallback = true }
            end
          '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
