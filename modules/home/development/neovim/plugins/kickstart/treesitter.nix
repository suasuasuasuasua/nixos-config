{ pkgs, ... }:
{
  programs.nixvim = {
    # Highlight, edit, and navigate code
    # https://nix-community.github.io/nixvim/plugins/treesitter/index.html
    plugins.treesitter = {
      enable = true;

      # By default, all available grammars packaged in the nvim-treesitter
      # package are installed.
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        diff
        html
        lua
        luadoc
        markdown
        markdown_inline
        nix
        query
        vim
        vimdoc
      ];

      settings = {
        # Highlight code snippets in nix
        nixvimInjections = true;

        highlight = {
          enable = true;

          # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          additional_vim_regex_highlighting = true;
        };

        indent.enable = true;

        # There are additional nvim-treesitter modules that you can use to
        # interact with nvim-treesitter. You should go explore a few and see
        # what interests you:
        #
        #    - Incremental selection: Included, see `:help
        #    nvim-treesitter-incremental-selection-mod`
        #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
        #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
      };

      # lazyLoad = {
      #   enable = true;
      #   settings = {
      #     user = "DeferredUIEnter";
      #   };
      # };
    };

    extraPackages = with pkgs; [
      gcc
      nodejs
      tree-sitter
    ];
  };
}
