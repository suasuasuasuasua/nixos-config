{
  lib,
  config,
  ...
}:
let
  name = "markview";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/OXY2DEV/markview.nvim
      plugins.markview = {
        enable = true;
        lazyLoad = {
          enable = true;
        };
      };
    };
  };
}
