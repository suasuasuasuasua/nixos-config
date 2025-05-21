{
  lib,
  config,
  ...
}:
let
  name = "diffview";
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
      # https://github.com/sindrets/diffview.nvim
      plugins.diffview = {
        enable = true;
      };

      plugins.lz-n = {
        # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
        plugins = [
          {
            __unkeyed-1 = "diffview.nvim"; # the plugin's name (:h packadd)
            after =
              # lua
              ''
                function()
                  require("diffview").setup()
                end
              '';
            event = [
              "DeferredUIEnter"
            ];
          }
        ];
      };
    };
  };
}
