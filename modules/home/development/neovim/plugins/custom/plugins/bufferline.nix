{
  lib,
  config,
  ...
}:
let
  name = "bufferline";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.bufferline = {
        enable = true;
      };

      opts = {
        termguicolors = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>bp";
          action = "<Cmd>BufferLineTogglePin<CR>";
          options = {
            desc = "Toggle Pin";
          };
        }
        {
          mode = "n";
          key = "<leader>bP";
          action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
          options = {
            desc = "Delete Non-Pinned Buffers";
          };
        }
        {
          mode = "n";
          key = "<leader>br";
          action = "<Cmd>BufferLineCloseRight<CR>";
          options = {
            desc = "Delete Buffers to the Right";
          };
        }
        {
          mode = "n";
          key = "<leader>bl";
          action = "<Cmd>BufferLineCloseLeft<CR>";
          options = {
            desc = "Delete Buffers to the Left";
          };
        }
        {
          mode = "n";
          key = "<S-h>";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options = {
            desc = "Prev Buffer";
          };
        }
        {
          mode = "n";
          key = "<S-l>";
          action = "<cmd>BufferLineCycleNext<cr>";
          options = {
            desc = "Next Buffer";
          };
        }
        {
          mode = "n";
          key = "[b";
          action = "<cmd>BufferLineCyclePrev<cr>";
          options = {
            desc = "Prev Buffer";
          };
        }
        {
          mode = "n";
          key = "]b";
          action = "<cmd>BufferLineCycleNext<cr>";
          options = {
            desc = "Next Buffer";
          };
        }
        {
          mode = "n";
          key = "[B";
          action = "<cmd>BufferLineMovePrev<cr>";
          options = {
            desc = "Move buffer prev";
          };
        }
        {
          mode = "n";
          key = "]B";
          action = "<cmd>BufferLineMoveNext<cr>";
          options = {
            desc = "Move buffer next";
          };
        }
      ];
    };
  };
}
