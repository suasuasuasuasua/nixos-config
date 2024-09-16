{
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
