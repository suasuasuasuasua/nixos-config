{
  programs.nixvim = {
    # Add indentation guides even on blank lines
    # For configuration see `:help ibl`
    # https://nix-community.github.io/nixvim/plugins/indent-blankline/index.html
    plugins.indent-blankline = {
      enable = true;

      lazyLoad = {
        enable = true;
        settings = {
          # LazyFile is a shorthand that lazy.nvim uses
          event = [ "BufReadPost BufWritePost BufNewFile" ];
        };
      };
    };
  };
}
