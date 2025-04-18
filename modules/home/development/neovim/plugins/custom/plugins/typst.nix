{
  lib,
  config,
  ...
}:
let
  name = "typst";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/kaarmu/typst.vim/
      plugins.typst-vim = {
        enable = true;
      };

      # https://github.com/chomosuke/typst-preview.nvim/
      plugins.typst-preview = {
        enable = true;
        # not yet enabled lazy loading provider
        lazyLoad = {
          enable = false;
          settings = {
            cmd = "TypstPreview";
          };
        };
      };
    };
  };
}
