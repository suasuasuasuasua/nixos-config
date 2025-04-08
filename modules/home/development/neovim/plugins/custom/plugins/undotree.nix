{
  lib,
  config,
  ...
}:
let
  name = "undotree";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/mbbill/undotree/
      plugins.undotree = {
        enable = true;
      };
    };
  };
}
