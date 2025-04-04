{
  programs.nixvim = {
    # You can easily change to a different colorscheme.
    # Add your colorscheme here and enable it.
    # Don't forget to disable the colorschemes you arent using
    #
    # If you want to see what colorschemes are already installed, you can use
    # `:Telescope colorschme`.
    colorschemes = {
      # https://nix-community.github.io/nixvim/colorschemes/tokyonight/index.html
      tokyonight = {
        enable = false;
        settings = {
          # Like many other themes, this one has different styles, and you could
          # load any other, such as 'storm', 'moon', or 'day'.
          style = "night";
        };
      };
    };
  };
}
