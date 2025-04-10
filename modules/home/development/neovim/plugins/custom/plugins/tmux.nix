{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "tmux";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/christoomey/vim-tmux-navigator
      plugins.tmux-navigator = {
        enable = true;
      };

      extraPlugins = with pkgs; [
        # https://github.com/aserowy/tmux.nvim
        vimPlugins.tmux-nvim
      ];
    };
  };
}
