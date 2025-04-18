{
  lib,
  config,
  ...
}:
let
  name = "lazygit";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/kdheepak/lazygit.nvim/
      plugins.lazygit = {
        enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>lg";
          action = "<cmd>LazyGit<cr>";
          options = {
            desc = "Open LazyGit";
          };
        }
      ];
    };
  };
}
