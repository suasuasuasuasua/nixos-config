{
  programs.nixvim = {
    plugins.lazygit = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>lg";
        action = "<cmd>LazyGit<cr>";
      }
    ];
  };
}
