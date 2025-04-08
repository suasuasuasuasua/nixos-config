{
  lib,
  config,
  ...
}:
let
  name = "ollama";
  cfg = config.home.development.neovim.plugins.${name};
in
{
  options.home.development.neovim.plugins.${name} = {
    enable = lib.mkEnableOption "Enable ${name} plugin for neovim";
    model = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    url = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      # https://github.com/nomnivore/ollama.nvim
      plugins.ollama = {
        inherit (cfg) model url;

        enable = true;
      };

      keymaps = [
        {
          mode = [
            "n"
            "v"
            "x"
            "s"
          ];
          key = "<leader>oo";
          action = "<cmd>Ollama<cr>";
          options = {
            desc = "Open Ollama context menu";
          };
        }
        {
          mode = "n";
          key = "<leader>om";
          action = "<cmd>OllamaModel<cr>";
          options = {
            desc = "Choose Ollama Model";
          };
        }
        {
          mode = "n";
          key = "<leader>os";
          action = "<cmd>OllamaServe<cr>";
          options = {
            desc = "Ollama Serve";
          };
        }
        {
          mode = "n";
          key = "<leader>op";
          action = "<cmd>OllamaServeStop<cr>";
          options = {
            desc = "Stop Ollama Serve";
          };
        }
      ];
    };
  };
}
