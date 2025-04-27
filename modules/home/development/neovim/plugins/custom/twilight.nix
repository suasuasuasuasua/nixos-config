{
  lib,
  config,
  ...
}:
let
  name = "twilight";
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
      # https://github.com/folke/twilight.nvim
      plugins.twilight = {
        enable = true;
      };
    };
  };
}
