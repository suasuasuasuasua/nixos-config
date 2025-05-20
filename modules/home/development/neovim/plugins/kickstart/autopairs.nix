{
  # Inserts matching pairs of parens, brackets, etc.
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  programs.nixvim = {
    plugins.nvim-autopairs = {
      enable = true;

      lazyLoad = {
        enable = true;

        settings = {
          event = "InsertEnter";
        };
      };
    };
  };
}
