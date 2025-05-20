{
  programs.nixvim = {
    # Detect tabstop and shiftwidth automatically
    plugins.guess-indent = {
      enable = true;
    };
  };
}
