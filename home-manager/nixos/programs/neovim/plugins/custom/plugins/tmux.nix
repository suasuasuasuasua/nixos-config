{pkgs,...}:
{
  programs.nixvim = {
    plugins.tmux-navigator = {
      enable = true;
    };

    extraConfigLua = ''
      require("tmux").setup({
      })
    '';
  };
}
