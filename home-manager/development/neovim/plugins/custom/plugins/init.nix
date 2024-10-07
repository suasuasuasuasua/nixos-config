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
  };
}
