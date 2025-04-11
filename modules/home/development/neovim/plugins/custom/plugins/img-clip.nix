{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "img-clip";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/HakonHarnes/img-clip.nvim
      extraPlugins = with pkgs.vimPlugins; [
        img-clip-nvim
      ];

      extraConfigLua =
        # lua
        ''
          require("img-clip").setup {
          };
        '';

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
