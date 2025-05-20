{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.home.development.neovim;
in
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./config.nix
    ./plugins/kickstart
    ./plugins/custom
  ];

  options.home.development.neovim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;

      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
      globals = {
        # Set <space> as the leader key
        # See `:help mapleader`
        mapleader = " ";
        maplocalleader = " ";

        # Set to true if you have a Nerd Font installed and selected in the terminal
        have_nerd_font = true; # we _should_ have nerd fonts
      };

      # [[ Setting options ]]
      # See `:help vim.opt`
      # NOTE: You can change these options as you wish!
      #  For more options, you can see `:help option-list`
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#opts
      opts = {
        # Show line numbers
        number = true;
        # You can also add relative line numbers, to help with jumping.
        #  Experiment for yourself to see if you like it!
        #relativenumber = true

        # Enable mouse mode, can be useful for resizing splits for example!
        mouse = "a";

        # Don't show the mode, since it's already in the statusline
        showmode = false;

        #  See `:help 'clipboard'`
        clipboard = {
          providers = {
            wl-copy.enable = true; # For Wayland
            xsel.enable = true; # For X11
          };

          # Sync clipboard between OS and Neovim
          #  Remove this option if you want your OS clipboard to remain independent.
          register = "unnamedplus";
        };

        # Enable break indent
        breakindent = true;

        # Save undo history
        undofile = true;

        # Case-insensitive searching UNLESS \C or one or more capital letters in search term
        ignorecase = true;
        smartcase = true;

        # Keep signcolumn on by default
        signcolumn = "yes";

        # Decrease update time
        updatetime = 250;

        # Decrease mapped sequence wait time
        # Displays which-key popup sooner
        timeoutlen = 300;

        # Configure how new splits should be opened
        splitright = true;
        splitbelow = true;

        # Sets how neovim will display certain whitespace characters in the editor
        #  See `:help 'list'`
        #  See `:help 'listchars'`
        list = true;
        # NOTE: .__raw here means that this field is raw lua code
        listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

        # Preview subsitutions live, as you type!
        inccommand = "split";

        # Show which line your cursor is on
        cursorline = true;

        # Minimal number of screen lines to keep above and below the cursor
        scrolloff = 10;

        # if performing an operation that would fail due to unsaved changes in
        # the buffer (like `:q`), instead raise a dialog asking if you wish to
        # save the current file(s)
        # See `:help 'confirm'`
        confirm = true;

        # See `:help hlsearch`
        hlsearch = true;

        # Expand the tabs for spaces
        expandtab = true;
        smarttab = true;
        shiftwidth = 2;
        tabstop = 2;
      };

      # [[ Basic Keymaps ]]
      #  See `:help vim.keymap.set()`
      # https://nix-community.github.io/nixvim/keymaps/index.html
      keymaps = [
        # Clear highlights on search when pressing <Esc> in normal mode
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>nohlsearch<CR>";
        }
        # Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
        # for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
        # is not what someone will guess without a bit more experience.
        #
        # NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
        # or just use <C-\><C-n> to exit terminal mode
        {
          mode = "t";
          key = "<Esc><Esc>";
          action = "<C-\\><C-n>";
          options = {
            desc = "Exit terminal mode";
          };
        }

        # Keybinds to make split navigation easier.
        #  Use CTRL+<hjkl> to switch between windows
        #
        #  See `:help wincmd` for a list of all window commands
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w><C-h>";
          options = {
            desc = "Move focus to the left window";
          };
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w><C-l>";
          options = {
            desc = "Move focus to the right window";
          };
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w><C-j>";
          options = {
            desc = "Move focus to the lower window";
          };
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w><C-k>";
          options = {
            desc = "Move focus to the upper window";
          };
        }
      ];

      # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
      autoGroups = {
        kickstart-highlight-yank = {
          clear = true;
        };
      };

      # [[ Basic Autocommands ]]
      #  See `:help lua-guide-autocommands`
      # https://nix-community.github.io/nixvim/NeovimOptions/autoCmd/index.html
      autoCmd = [
        # Highlight when yanking (copying) text
        #  Try it with `yap` in normal mode
        #  See `:help vim.highlight.on_yank()`
        {
          event = [ "TextYankPost" ];
          desc = "Highlight when yanking (copying) text";
          group = "kickstart-highlight-yank";
          callback.__raw =
            # lua
            ''
              function()
                -- TODO: vim.hl.on_yank() on nvim.version=0.11
                vim.highlight.on_yank()
              end
            '';
        }
      ];

      # The line beneath this is called `modeline`. See `:help modeline`
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
      extraConfigLuaPost =
        # lua
        ''
          -- vim: ts=2 sts=2 sw=2 et
        '';
    };
  };
}
