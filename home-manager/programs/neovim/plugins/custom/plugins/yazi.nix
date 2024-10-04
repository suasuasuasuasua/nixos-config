{
  programs.nixvim = {
    plugins.yazi = {
      enable = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>-";
        action = "<cmd>Yazi<cr>";
      }
      {
        mode = "n";
        key = "<leader>cw";
        action = "<cmd>Yazi cwd<cr>";
      }
    ];
  };
}
