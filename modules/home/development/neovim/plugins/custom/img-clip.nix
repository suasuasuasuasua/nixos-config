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

      plugins.lz-n = {
        # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
        plugins = [
          {
            __unkeyed-1 = "img-clip.nvim"; # the plugin's name (:h packadd)
            after =
              # lua
              ''
                function()
                  require('img-clip').setup()
                end
              '';
            event = [
              "DeferredUIEnter"
            ];
          }
        ];
      };

      extraPackages =
        let
          inherit (lib) optionals;
          inherit (pkgs.stdenv) isDarwin isLinux;
        in
        with pkgs;
        optionals isDarwin [
          pngpaste # macOS
        ]
        ++ optionals isLinux [
          xclip # x11
          wl-clipboard # wayland
        ];
    };
  };
}
