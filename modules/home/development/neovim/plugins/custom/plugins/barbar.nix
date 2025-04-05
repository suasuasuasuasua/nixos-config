{
  lib,
  config,
  ...
}:
let
  name = "barbar";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      plugins.barbar = {
        enable = true;

        keymaps = {
          # Move to previous/next
          previous = {
            action = "<Cmd>BufferPrevious<CR>";
            key = "<A-[>";
            mode = "n";
          };
          next = {
            action = "<Cmd>BufferNext<CR>";
            key = "<A-]>";
            mode = "n";
          };

          # Re-order to previous/next
          movePrevious = {
            action = "<Cmd>BufferMovePrevious<CR>";
            key = "<A-{>";
            mode = "n";
          };
          moveNext = {
            action = "<Cmd>BufferMoveNext<CR>";
            key = "<A-}>";
            mode = "n";
          };

          # Goto buffer in position
          goTo1 = {
            action = "<Cmd>BufferGo<CR>to 1";
            key = "<A-1>";
            mode = "n";
          };
          goTo2 = {
            action = "<Cmd>BufferGo<CR>to 2";
            key = "<A-2>";
            mode = "n";
          };
          goTo3 = {
            action = "<Cmd>BufferGo<CR>to 3";
            key = "<A-3>";
            mode = "n";
          };
          goTo4 = {
            action = "<Cmd>BufferGo<CR>to 4";
            key = "<A-4>";
            mode = "n";
          };
          goTo5 = {
            action = "<Cmd>BufferGo<CR>to 5";
            key = "<A-5>";
            mode = "n";
          };
          goTo6 = {
            action = "<Cmd>BufferGo<CR>to 6";
            key = "<A-6>";
            mode = "n";
          };
          goTo7 = {
            action = "<Cmd>BufferGo<CR>to 7";
            key = "<A-7>";
            mode = "n";
          };
          goTo8 = {
            action = "<Cmd>BufferGo<CR>to 8";
            key = "<A-8>";
            mode = "n";
          };
          goTo9 = {
            action = "<Cmd>BufferGo<CR>to 9";
            key = "<A-9>";
            mode = "n";
          };

          # Pin/unpin buffer
          pin = {
            action = "<Cmd>BufferPin<CR>";
            key = "<A-p>";
            mode = "n";
          };

          # Goto pinned/unpinned buffer
          #                          :BufferGotoPinned
          #                          :BufferGotoUnpinned

          # Close buffer
          close = {
            action = "<Cmd>BufferClose<CR>";
            key = "<A-w>";
            mode = "n";
          };
          # Restore buffer
          restore = {
            action = "<Cmd>BufferRestore<CR>";
            key = "<A-s-c>";
            mode = "n";
          };

          # Wipeout buffer
          #                          :BufferWipeout
          # Close commands
          #                          :BufferCloseAllButCurrent
          #                          :BufferCloseAllButVisible
          #                          :BufferCloseAllButPinned
          #                          :BufferCloseAllButCurrentOrPinned
          #                          :BufferCloseBuffersLeft
          #                          :BufferCloseBuffersRight

          # Magic buffer-picking mode
          pick = {
            action = "<Cmd>BufferPick<CR>";
            key = "<C-p>";
            mode = "n";
          };
          pickDelete = {
            action = "<Cmd>BufferPickDelete<CR>";
            key = "<C-p>";
            mode = "n";
          };

          # Sort automatically by...
          orderByBufferNumber = {
            action = "<Cmd>BufferOrderByBufferNumber<CR>";
            key = "<Leader>bb";
            mode = "n";
          };
          orderByName = {
            action = "<Cmd>BufferOrderByBufferName<CR>";
            key = "<Leader>bn";
            mode = "n";
          };
          orderByDirectory = {
            action = "<Cmd>BufferOrderByDirectory<CR>";
            key = "<Leader>bd";
            mode = "n";
          };
          orderByLanguage = {
            action = "<Cmd>BufferOrderByLanguage<CR>";
            key = "<Leader>bl";
            mode = "n";
          };
          orderByWindowNumber = {
            action = "<Cmd>BufferOrderByWindowNumber<CR>";
            key = "<Leader>bw";
            mode = "n";
          };

          # Other
          # :BarbarEnable - enables barbar (enabled by default)
          # :BarbarDisable - very bad command, should never be used
        };

        settings = {
          animation = false;
        };
      };
    };
  };
}
