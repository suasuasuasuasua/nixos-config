{
  lib,
  config,
  ...
}:
let
  name = "oil";
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
      # https://github.com/stevearc/oil.nvim
      plugins.oil = {
        enable = true;

        settings = {
          # Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
          # Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
          default_file_explorer = true;

          # Id is automatically added at the beginning, and name at the end
          # See :help oil-columns
          columns = [
            "icon"
            # "permissions"
            # "size"
            # "mtime"
          ];

          # Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
          delete_to_trash = false;

          # Configuration for the floating window in oil.open_float
          float = {
            # Padding around the floating window
            padding = 12;
            # max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            max_width = 0;
            max_height = 0;
            border = "rounded";
            win_options = {
              winblend = 0;
            };
            # optionally override the oil buffers window title with custom function: fun(winid: integer): string
            get_win_title = null;
            # preview_split: Split direction: "auto", "left", "right", "above", "below".
            preview_split = "auto";
          };
        };

        # NOTE: not recommended according to GitHub
        lazyLoad = {
          enable = false;
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "-";
          action = "<CMD>Oil<CR>";
          options = {
            desc = "Open parent directory";
          };
        }
        {
          mode = "n";
          key = "_";
          action = "<CMD>Oil --float<CR>";
          options = {
            desc = "Open parent directory (float)";
          };
        }
      ];
    };
  };
}
