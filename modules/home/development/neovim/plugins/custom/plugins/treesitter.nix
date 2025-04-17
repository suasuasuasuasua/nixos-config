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
        enable = false;
        # TODO: https://github.com/nvim-treesitter/nvim-treesitter-context?tab=readme-ov-file#configuration
        # research the settings when i have time. just annoying especially on
        # long nix files
      };
      # https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      plugins.treesitter-textobjects = {
        enable = true;
      };
    };
  };
}
