{
  lib,
  config,
  ...
}:
let
  name = "treesitter";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/nvim-treesitter/nvim-treesitter-context
      plugins.treesitter-context = {
        enable = true;
      };
      # https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      plugins.treesitter-textobjects = {
        enable = true;
      };
    };
  };
}
