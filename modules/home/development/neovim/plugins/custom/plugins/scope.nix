{
  lib,
  config,
  ...
}:
let
  name = "scope";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/tiagovla/scope.nvim
      plugins.scope = {
        enable = true;
      };

      opts = {
        termguicolors = true;
      };
    };
  };
}
