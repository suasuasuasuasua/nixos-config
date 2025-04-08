{
  lib,
  pkgs,
  config,
  ...
}:
let
  name = "render-markdown";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/MeanderingProgrammer/render-markdown.nvim
      plugins.render-markdown = {
        enable = true;
        # not yet enabled lazy loading provider
        lazyLoad = {
          enable = false;
          settings = {
            ft = "markdown";
          };
        };
        settings = {
          latex = {
            enabled = false; # latex kinda annoying when bouncing around
          };
        };
      };

      extraPackages = with pkgs; [
        python312Packages.pylatexenc
      ];
    };
  };
}
