{
  lib,
  config,
  ...
}:
let
  name = "repeat";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/tpope/vim-repeat
      plugins.repeat = {
        enable = true;
      };
    };
  };
}
