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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
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

        lazyLoad = {
          enable = true;
          settings = {
            cmd = "TypstPreview";
            ft = "typst";
          };
        };
      };
    };
  };
}
