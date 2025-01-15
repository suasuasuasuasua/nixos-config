{
  programs.nixvim = {
    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          integrations = {
            cmp = true;
            gitsigns = true;
            nvimtree = true;
            treesitter = true;
            notify = false;
            mini = {
              enabled = true;
              indentscope_color = "";
            };
          };
        };
      };
    };
  };
}
