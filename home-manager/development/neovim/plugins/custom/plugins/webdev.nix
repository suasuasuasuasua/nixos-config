{
  programs.nixvim = {
    # Auto tags completions in html and whatnot
    plugins.ts-autotag = {
      enable = true;
    };

    # Typescript support
    plugins.typescript-tools = {
      enable = true;
    };

    # Color preview for CSS
    plugins.vim-css-color = {
      enable = true;
    };
  };
}
