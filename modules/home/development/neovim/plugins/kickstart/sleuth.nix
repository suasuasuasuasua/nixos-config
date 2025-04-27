{
  programs.nixvim = {
    # Detect tabstop and shiftwidth automatically
    plugins.sleuth = {
      enable = true;
    };
  };
}
