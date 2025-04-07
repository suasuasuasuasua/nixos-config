{
  lib,
  config,
  ...
}:
let
  name = "hex";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.hex = {
        enable = true;
      };
    };
  };
}
