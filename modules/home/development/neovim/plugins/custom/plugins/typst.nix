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
      plugins.typst-vim = {
        enable = true;
      };

      plugins.typst-preview = {
        enable = true;
      };
    };
  };
}
