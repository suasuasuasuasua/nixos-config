{
  programs.nixvim = {
    plugins.neogen = {
      enable = true;
      # Configure for language specific comment templates
      # languages = { };
    };
  };
}
