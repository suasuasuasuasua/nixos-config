{
  lib,
  config,
  ...
}:
let
  name = "auto-save";
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
      # https://github.com/okuuva/auto-save.nvim/
      plugins.auto-save = {
        enable = true;
      };
    };
  };
}
