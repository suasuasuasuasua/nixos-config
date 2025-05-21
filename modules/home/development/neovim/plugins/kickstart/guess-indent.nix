{
  programs.nixvim = {
    # Detect tabstop and shiftwidth automatically
    plugins.guess-indent = {
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
        };
      };
    };
  };
}
