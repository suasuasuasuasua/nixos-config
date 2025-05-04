{
  config,
  lib,
  ...
}:
let
  cfg = config.home.development.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      opts = {
        cc = "80,81";
        textwidth = 80;
        conceallevel = 2;

        backup = false;
        writebackup = false;
        swapfile = false;
      };
      keymaps = [
        {
          mode = "i";
          key = "jk";
          action = "<Esc>";
        }
        {
          mode = "t";
          key = "jk";
          action = "<C-\\><C-n>";
          options = {
            desc = "Exit terminal mode (jk)";
          };
        }
      ];

      # Performance tweaks
      # https://nix-community.github.io/nixvim/performance/byteCompileLua.html
      performance.byteCompileLua = {
        enable = true;
        configs = true;
        initLua = true;
        nvimRuntime = true;
        plugins = true;
      };

      # Persistent folds
      #   Source: https://github.com/AstroNvim/AstroNvim/blob/271c9c3f71c2e315cb16c31276dec81ddca6a5a6/lua/astronvim/autocmds.lua#L98-L120
      autoGroups = {
        "auto_view" = {
          clear = true;
        };
      };
      autoCmd = [
        {
          desc = "Save view with mkview for real files";
          group = "auto_view";
          event = [
            "BufWinLeave"
            "BufWritePost"
            "WinLeave"
          ];
          callback.__raw =
            # lua
            ''
              function(args)
                if vim.b[args.buf].view_activated then
                  vim.cmd.mkview { mods = { emsg_silent = true } }
                end
              end
            '';
        }
        {
          desc = "Try to load file view if available and enable view saving for
          real files";
          group = "auto_view";
          event = [
            "BufWinEnter"
          ];
          callback.__raw =
            # lua
            ''
              function(args)
                if not vim.b[args.buf].view_activated then
                  local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
                  local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
                  local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
                  if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
                    vim.b[args.buf].view_activated = true
                    vim.cmd.loadview { mods = { emsg_silent = true } }
                  end
                end
              end
            '';
        }
      ];
    };
  };
}
