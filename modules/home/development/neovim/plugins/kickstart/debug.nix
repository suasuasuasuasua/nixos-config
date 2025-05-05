{
  programs.nixvim = {
    # Shows how to use the DAP plugin to debug your code.
    #
    # Primarily focused on configuring the debugger for Go, but can
    # be extended to other languages as well. That's why it's called
    # kickstart.nixvim and not ktichen-sink.nixvim ;)
    # https://nix-community.github.io/nixvim/plugins/dap/index.html

    # TODO: move the keymaps and setup into lazyLoad settings
    plugins = {
      dap = {
        enable = true;
      };

      # Add your own debuggers here
      dap-go = {
        enable = true;
      };

      dap-ui = {
        enable = true;

        # Set icons to characters that are more likely to work in every terminal.
        # Feel free to remove or use ones that you like more! :)
        # Don't feel like these are good choices.
        settings = {
          icons = {
            expanded = "▾";
            collapsed = "▸";
            current_frame = "*";
          };
          controls = {
            icons = {
              pause = "⏸";
              play = "▶";
              step_into = "⏎";
              step_over = "⏭";
              step_out = "⏮";
              step_back = "b";
              run_last = "▶▶";
              terminate = "⏹";
              disconnect = "⏏";
            };
          };
        };
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        mode = "n";
        key = "<F5>";
        action.__raw =
          # lua
          ''
            function()
              require('dap').continue()
            end
          '';
        options = {
          desc = "Debug: Start/Continue";
        };
      }
      {
        mode = "n";
        key = "<F1>";
        action.__raw =
          # lua
          ''
            function()
              require('dap').step_into()
            end
          '';
        options = {
          desc = "Debug: Step Into";
        };
      }
      {
        mode = "n";
        key = "<F2>";
        action.__raw =
          # lua
          ''
            function()
              require('dap').step_over()
            end
          '';
        options = {
          desc = "Debug: Step Over";
        };
      }
      {
        mode = "n";
        key = "<F3>";
        action.__raw =
          # lua
          ''
            function()
              require('dap').step_out()
            end
          '';
        options = {
          desc = "Debug: Step Out";
        };
      }
      {
        mode = "n";
        key = "<leader>b";
        action.__raw =
          # lua
          ''
            function()
              require('dap').toggle_breakpoint()
            end
          '';
        options = {
          desc = "Debug: Toggle Breakpoint";
        };
      }
      {
        mode = "n";
        key = "<leader>B";
        action.__raw =
          # lua
          ''
            function()
              require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
            end
          '';
        options = {
          desc = "Debug: Set Breakpoint";
        };
      }
      # Toggle to see last session result. Without this, you can't see session output
      # in case of unhandled exception.
      {
        mode = "n";
        key = "<F7>";
        action.__raw =
          # lua
          ''
            function()
              require('dapui').toggle()
            end
          '';
        options = {
          desc = "Debug: See last session result.";
        };
      }
    ];

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
    extraConfigLua =
      # lua
      ''
        local dap = require 'dap'
        local dapui = require 'dapui'

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
      '';
  };
}
