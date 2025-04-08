{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "clipboard-image";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/ekickx/clipboard-image.nvim/
      plugins.clipboard-image = {
        enable = true;
        # not yet enabled lazy loading provider
        lazyLoad = {
          enable = false;
          settings = {
            cmd = "PasteImg";
          };
        };
      };

      extraPackages =
        with pkgs;
        if stdenv.isDarwin then
          [
            pngpaste # paste image files from clipbaord to file on macOS
          ]
        else if stdenv.isLinux then
          [
            xclip # x11
            wl-clipboard # wayland
          ]
        else
          [
            # something horrible has gone wrong!
          ];

    };
  };
}
