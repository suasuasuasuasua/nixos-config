{
  lib,
  config,
  ...
}:
let
  name = "lz-n";
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
      # https://github.com/nvim-neorocks/lz.n
      plugins.lz-n = {
        enable = true;

        # https://nix-community.github.io/nixvim/plugins/lz-n/plugins.html
        plugins = [
          # neotree
          {
            __unkeyed-1 = "neo-tree.nvim"; # the plugin's name (:h packadd)
            after = ''
              function()
                require("neo-tree").setup()
              end
            '';
            enabled = ''
              function()
              return true
              end
            '';
            keys = [
              {
                __unkeyed-1 = "<leader>ft";
                __unkeyed-2 = "<CMD>Neotree toggle<CR>";
                desc = "NeoTree toggle";
              }
            ];
          }
          # telescope
          {
            __unkeyed-1 = "telescope.nvim";
            cmd = [
              "Telescope"
            ];
            keys = [
              {
                __unkeyed-1 = "<leader>fa";
                __unkeyed-2 = "<CMD>Telescope autocommands<CR>";
                desc = "Telescope autocommands";
              }
              {
                __unkeyed-1 = "<leader>fb";
                __unkeyed-2 = "<CMD>Telescope buffers<CR>";
                desc = "Telescope buffers";
              }
            ];
          }
        ];

        # :h autocmd-events
        settings = { };
      };
    };
  };
}
