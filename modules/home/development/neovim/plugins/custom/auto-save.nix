{
  lib,
  config,
  ...
}:
let
  name = "auto-save";
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
      # https://github.com/okuuva/auto-save.nvim/
      plugins.auto-save = {
        enable = true;

        settings = {
          condition.__raw =
            # lua
            ''
              function(buf)
                local fn = vim.fn

                -- don't save for special-buffers
                if fn.getbufvar(buf, "&buftype") ~= "" then
                  return false
                end
                return true
              end
            '';
        };

        lazyLoad = {
          enable = true;
          settings = {
            cmd = "ASToggle";
            event = [
              "InsertLeave"
              "TextChanged"
            ];
          };
        };
      };
    };
  };
}
