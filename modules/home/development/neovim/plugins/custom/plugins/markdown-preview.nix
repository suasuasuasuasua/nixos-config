{
  lib,
  config,
  ...
}:
let
  name = "markdown-preview";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/iamcco/markdown-preview.nvim/
      plugins.markdown-preview = {
        enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>mp";
          action = "<cmd>MarkdownPreview<cr>";
          options = {
            desc = "Start Markdown Preview server";
          };
        }
      ];
    };
  };
}
