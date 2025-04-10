{
  lib,
  config,
  ...
}:
let
  name = "zen-mode";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/folke/zen-mode.nvim
      plugins.zen-mode = {
        enable = true;
        # not yet enabled lazy loading provider
        lazyLoad = {
          enable = false;
          settings = {
            cmd = "ZenMode";
          };
        };
      };
    };
  };
}
