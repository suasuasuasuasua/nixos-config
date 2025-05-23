{
  programs.nixvim = {
    # Linting
    # https://nix-community.github.io/nixvim/plugins/lint/index.html
    plugins.lint = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          # equivalent to config (lazy.nvim)
          after =
            # lua
            ''
              function()
                -- TODO: don't like doing it this way, but only way to lazy load
                -- the lint plugin. There is the default interface but that
                -- breaks because of the autocmd here that needs to be loaded
                -- after
                local lint = require('lint')

                -- disable the default linters
                for key in pairs(lint.linters_by_ft) do
                    lint.linters_by_ft[key] = nil
                end


                local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
                vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
                  group = lint_augroup,
                  callback = function()
                    -- Only run the linter in buffers that you can modify in order to
                    -- avoid superfluous noise, notably within the handy LSP pop-ups that
                    -- describe the hovered symbol using Markdown.
                    if vim.bo.modifiable then
                      lint.try_lint()
                    end
                  end,
                })
              end
            '';

          # equivalent to event (lazy.nvim)
          event = [
            "BufReadPre"
            "BufNewFile"
          ];
        };
      };
    };
  };
}
