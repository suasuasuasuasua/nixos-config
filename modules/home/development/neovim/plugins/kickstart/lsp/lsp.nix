{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    plugins = {
      # Dependencies
      # { 'Bilal2453/luvit-meta', lazy = true },
      #
      #
      # Allows extra capabilities providied by nvim-cmp
      # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
      cmp-nvim-lsp.enable = true;

      # Useful status updates for LSP.
      # https://nix-community.github.io/nixvim/plugins/fidget/index.html
      fidget = {
        enable = true;

        lazyLoad = {
          enable = true;
          settings = {
            # LazyFile is a shorthand that lazy.nvim uses
            event = [ "BufReadPost BufWritePost BufNewFile" ];
          };
        };
      };

      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };

      # Brief aside: **What is LSP?**
      #
      # LSP is an initialism you've probably heard, but might not understand
      # what it is.
      #
      # LSP stands for Language Server Protocol. It's a protocol that helps
      # editors and language tooling communicate in a standardized fashion.
      #
      # In general, you have a "server" which is some tool built to understand a
      # particular language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.).
      # These Language Servers (sometimes called LSP servers, but that's kind of
      # like ATM Machine) are standalone processes that communicate with some
      # "client" - in this case, Neovim!
      #
      # LSP provides Neovim with features like:
      #  - Go to definition
      #  - Find references
      #  - Autocompletion
      #  - Symbol Search
      #  - and more!
      #
      # Thus, Language Servers are external tools that must be installed
      # separately from Neovim which are configured below in the `server`
      # section.
      #
      # If you're wondering about lsp vs treesitter, you can check out the
      # wonderfully and elegantly composed help section, `:help
      # lsp-vs-treesitter`
      #
      # https://nix-community.github.io/nixvim/plugins/lsp/index.html
      lsp = {
        enable = true;

        # Enable the following language servers
        #  Feel free to add/remove any LSPs that you want here. They will
        #  automatically be installed.
        #
        #  Add any additional override configuration in the following tables.
        #  Available keys are:
        #  - cmd: Override the default command used to start the server
        #  - filetypes: Override the default list of associated filetypes for
        #  the server
        #  - capabilities: Override fields in capabilities. Can be used to
        #  disable certain LSP features.
        #  - settings: Override the default settings passed when initializing
        #  the server.
        #        For example, to see the options for `lua_ls`, you could go to:
        #        https://luals.github.io/wiki/settings/
        # NOTE: see the individual files...
        servers = { };

        keymaps = {
          # Diagnostic keymaps
          diagnostic = {
            "<leader>q" = {
              #mode = "n";
              action = "setloclist";
              desc = "Open diagnostic [Q]uickfix list";
            };
          };

          extra = [
            # Jump to the definition of the word under your cusor.
            #  This is where a variable was first declared, or where a function is defined, etc.
            #  To jump back, press <C-t>.
            {
              mode = "n";
              key = "gd";
              action.__raw = "require('telescope.builtin').lsp_definitions";
              options = {
                desc = "LSP: [G]oto [D]efinition";
              };
            }
            # Find references for the word under your cursor.
            {
              mode = "n";
              key = "gr";
              action.__raw = "require('telescope.builtin').lsp_references";
              options = {
                desc = "LSP: [G]oto [R]eferences";
              };
            }
            # Jump to the implementation of the word under your cursor.
            #  _seful when your language has ways of declaring types without an actual implementation.
            {
              mode = "n";
              key = "gI";
              action.__raw = "require('telescope.builtin').lsp_implementations";
              options = {
                desc = "LSP: [G]oto [I]mplementation";
              };
            }
            # Jump to the type of the word under your cursor.
            #  Useful when you're not sure what type a variable is and you want to see
            #  the definition of its *type*, not where it was *defined*.
            {
              mode = "n";
              key = "<leader>D";
              action.__raw = "require('telescope.builtin').lsp_type_definitions";
              options = {
                desc = "LSP: Type [D]efinition";
              };
            }
            # Fuzzy find all the symbols in your current document.
            #  Symbols are things like variables, functions, types, etc.
            {
              mode = "n";
              key = "<leader>ds";
              action.__raw = "require('telescope.builtin').lsp_document_symbols";
              options = {
                desc = "LSP: [D]ocument [S]ymbols";
              };
            }
            # Fuzzy find all the symbols in your current workspace.
            #  Similar to document symbols, except searches over your entire project.
            {
              mode = "n";
              key = "<leader>ws";
              action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
              options = {
                desc = "LSP: [W]orkspace [S]ymbols";
              };
            }
          ];

          lspBuf = {
            # Rename the variable under your cursor.
            #  Most Language Servers support renaming across files, etc.
            "<leader>rn" = {
              action = "rename";
              desc = "LSP: [R]e[n]ame";
            };
            # Execute a code action, usually your cursor needs to be on top of an error
            # or a suggestion from your LSP for this to activate.
            "<leader>ca" = {
              #mode = "n";
              action = "code_action";
              desc = "LSP: [C]ode [A]ction";
            };
            # WARN: This is not Goto Definition, this is Goto Declaration.
            #  For example, in C this would take you to the header.
            "gD" = {
              action = "declaration";
              desc = "LSP: [G]oto [D]eclaration";
            };
          };
        };

        # LSP servers and clients are able to communicate to each other what
        # features they support.
        #  By default, Neovim doesn't support everything that is in the LSP
        #  specification. When you add nvim-cmp, luasnip, etc. Neovim now has
        #  *more* capabilities. So, we create new capabilities with nvim cmp,
        #  and then broadcast that to the servers.
        # NOTE: This is done automatically by Nixvim when enabling cmp-nvim-lsp
        # below is an example if you did want to add new capabilities
        # capabilities = ''
        #   capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
        # '';

        # This function gets run when an LSP attaches to a particular buffer.
        #   That is to say, every time a new file is opened that is associated
        #   with an lsp (for example, opening `main.rs` is associated with
        #   `rust_analyzer`) this function will be executred to configure the
        #   current buffer
        # NOTE: client and bufnr is provided (nixvim)
        # NOTE: This is an example of an attribute that takes raw lua
        onAttach =
          # lua
          ''
            -- NOTE: Remember that Lua is a real programming language, and as
            -- such it is possible to define small helper and utility functions
            -- so you don't have to repeat yourself.
            --
            -- In this case, we create a function that lets us more easily
            -- define mappings specific for LSP related items. It sets the mode,
            -- buffer and description for us each time.
            local map = function(keys, func, desc)
              vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
            end

            -- This function resolves a difference between neovim nightly
            -- (version 0.11) and stable (version 0.10)
            ---@param client vim.lsp.Client
            ---@param method vim.lsp.protocol.Method
            ---@param bufnr? integer some lsp support methods only in specific files
            ---@return boolean
            local function client_supports_method(client, method, bufnr)
              if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
              else
                return client.supports_method(method, { bufnr = bufnr })
              end
            end

            -- The following two autocommands are used to highlight references
            -- of the word under your cursor when your cursor rests there for a
            -- little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the
            -- second autocommand).
            if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
              local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = bufnr }
                end,
              })
            end

            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                  bufnr = bufnr })
              end, '[T]oggle Inlay [H]ints')
            end
          '';
      };
    };

    diagnostic.settings = {
      severity_sort = true;
      float = {
        border = "rounded";
        source = "if_many";
      };
      # underline = {
      #   # TODO: invalid option?
      #   # severity = "vim.diagnostic.severity.ERROR";
      # };
      signs = lib.mkIf config.programs.nixvim.globals.have_nerd_font {
        text.vim.diagnostic.severity = {
          ERROR = "󰅚 ";
          WARN = "󰀪 ";
          INFO = "󰋽 ";
          HINT = "󰌶 ";
        };
      };
      virtual_text = {
        source = "if_many";
        spacing = 2;
        format.__raw =
          # lua
          ''
              function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end
          '';
      };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugi#extraplugins
    extraPlugins = with pkgs.vimPlugins; [
      # NOTE: This is where you would add a vim plugin that is not implemented
      # in Nixvim, also see extraConfigLuaPre below
      luvit-meta
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      "kickstart-lsp-attach" = {
        clear = true;
      };
    };
  };
}
