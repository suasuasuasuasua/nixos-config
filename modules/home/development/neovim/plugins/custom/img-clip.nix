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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable ${name} plugin for neovim";
    };
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
        with lib;
        optionals stdenv.isDarwin [
          pngpaste # macOS
        ]
        ++ optionals stdenv.isLinux [
          xclip # x11
          wl-clipboard # wayland
        ];
    };
  };
}
