{
  programs.nixvim = {
    # `lazydev` configures Lua LSP for your Neovim config, runtime and
    # plugins used for completion, annotations and signatures of Neovim apis
    plugins.lazydev = {
      enable = true;
    };
  };
}
