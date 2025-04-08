{
  lib,
  config,
  ...
}:
let
  name = "surround";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/tpope/vim-surround
      plugins.vim-surround = {
        enable = true;
      };
    };
  };
}
