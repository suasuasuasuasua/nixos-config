{
  programs.nixvim = {
    # Highlight todo, notes, etc in comments
    # https://nix-community.github.io/nixvim/plugins/todo-comments/index.html
    plugins.todo-comments = {
      enable = true;

      settings = {
        signs = false;
      };

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
