{
  # Inserts matching pairs of parens, brackets, etc.
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = true;

      lazyLoad = {
        enable = true;

        settings = {
          # TODO: figure this out...
          # # If you want to automatically add `(` after selecting a function or method
          # # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
          # after.__raw =
          #   # lua
          #   ''
          #     function()
          #       local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
          #       local cmp = require 'cmp'
          #
          #       cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
          #     end
          #   '';
          event = "InsertEnter";
        };
      };
    };
  };
}
