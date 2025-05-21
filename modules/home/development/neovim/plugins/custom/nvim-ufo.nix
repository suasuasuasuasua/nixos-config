{
  lib,
  config,
  ...
}:
let
  name = "nvim-ufo";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.nvim-ufo = {
        # https://github.com/kevinhwang91/nvim-ufo
        enable = true;

        lazyLoad = {
          enable = true;

          settings = {
            # LazyFile is a shorthand that lazy.nvim uses
            event = [
              "BufReadPost"
              "BufWritePost"
              "BufNewFile"
            ];
            after =
              # lua
              ''
                function()
                  -- Option 3: treesitter as a main provider instead
                  -- (Note: the `nvim-treesitter` plugin is *not* needed.)
                  -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
                  -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
                  require('ufo').setup({
                    provider_selector = function(bufnr, filetype, buftype)
                      return {'treesitter', 'indent'}
                    end
                  })
                end
              '';
            # NOTE: doesn't work well with the folding for some reason
            # keys = [
            #   {
            #     _unkeyed-1 = "zR";
            #     __unkeyed-3.__raw =
            #       # lua
            #       ''
            #         function() require('ufo').openAllFolds() end
            #       '';
            #     mode = "n";
            #     desc = "Open all Folds (UFO)";
            #   }
            #   {
            #     __unkeyed-1 = "zM";
            #     __unkeyed-3.__raw =
            #       # lua
            #       ''
            #         function() require('ufo').closeAllFolds() end
            #       '';
            #     mode = "n";
            #     desc = "Close all Folds (UFO)";
            #   }
            # ];
          };
        };
      };
    };
  };
}
