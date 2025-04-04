{
  lib,
  config,
  ...
}:
let
  name = "ufo";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      opts = {
        foldenable = true;
        foldcolumn = "auto";
        foldlevel = 99;
        foldlevelstart = 99;
      };

      keymaps = [
        {
          mode = "n";
          key = "zR";
          action =
            # lua
            ''
              function()
                require("ufo").openAllFolds()
              end
            '';
        }
        {
          mode = "n";
          key = "zM";
          action =
            # lua
            ''
              function()
                require("ufo").closeAllFolds()
              end
            '';
        }
      ];

      plugins.nvim-ufo = {
        enable = true;
        settings = {
          fold_virt_text_handler =
            # lua
            ''
              function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ('  %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                  local chunkText = chunk[1]
                  local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                  else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                      suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                  end
                  curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, 'MoreMsg'})
                return newVirtText
              end
            '';
          provider_selector =
            # lua
            ''
              -- Option 3: treesitter as a main provider instead
              -- (Note: the `nvim-treesitter` plugin is *not* needed.)
              -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
              -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
              require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                  return {'treesitter', 'indent'}
                end
              })
            '';
        };
      };
    };
  };
}
