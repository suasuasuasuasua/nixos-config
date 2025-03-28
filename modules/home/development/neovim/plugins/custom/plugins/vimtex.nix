{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "vimtex";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.vimtex = {
        enable = true;
      };

      extraPackages = with pkgs; [
        biber
      ];
    };
  };
}
