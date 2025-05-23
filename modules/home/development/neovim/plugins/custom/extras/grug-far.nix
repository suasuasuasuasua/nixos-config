{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "grug-far";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/MagicDuck/grug-far.nvim/
      plugins.grug-far = {
        enable = true;
      };

      extraPackages = with pkgs; [
        ast-grep
      ];
    };
  };
}
