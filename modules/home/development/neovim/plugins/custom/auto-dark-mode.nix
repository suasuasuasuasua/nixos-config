{
  lib,
  config,
  pkgs,
  ...
}:
let
  name = "auto-dark-mode";
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
      extraPlugins = [
        # https://github.com/f-person/auto-dark-mode.nvim
        (pkgs.vimUtils.buildVimPlugin {
          name = "auto-dark-mode";
          src = pkgs.fetchFromGitHub {
            owner = "f-person";
            repo = "auto-dark-mode.nvim";
            rev = "c31de126963ffe9403901b4b0990dde0e6999cc6";
            hash = "sha256-ZCViqnA+VoEOG+Xr+aJNlfRKCjxJm5y78HRXax3o8UY=";
          };
        })
      ];

      plugins.lz-n = {
        # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
        plugins = [
          {
            __unkeyed-1 = "auto-dark-mode.nvim"; # the plugin's name (:h packadd)
            after =
              # lua
              ''
                function()
                  require('auto-dark-mode').setup {
                    set_dark_mode = function()
                      vim.api.nvim_set_option_value("background", "dark", {})
                    end,
                    set_light_mode = function()
                      vim.api.nvim_set_option_value("background", "light", {})
                    end,
                    update_interval = 3000,
                    fallback = "dark"
                  };
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
