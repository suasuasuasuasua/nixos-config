{
  programs.nixvim = {
    opts = {
      # vim.o.foldcolumn = '1' -- '0' is not bad
      # vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free
      #                         to decrease the value
      # vim.o.foldlevelstart = 99
      # vim.o.foldenable = true
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
    };

    keymaps = [
      # TODO: not working for some reason??
      # -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1,
      #    remap yourself
      # vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      # vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      # {
      #   mode = "n";
      #   key = "zR";
      #   action = "require('ufo').openAllFolds";
      # }
      # {
      #   mode = "n";
      #   key = "zM";
      #   action = "require('ufo').closeAllFolds";
      # }
    ];

    plugins.nvim-ufo = {
      enable = true;
      providerSelector = ''
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
}
