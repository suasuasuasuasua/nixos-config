{pkgs,...}:
{
  programs.nixvim = {
    plugins.tmux-navigator = {
      enable = true;
    };

    extraPlugins = [
      vimPlugins.tmux
    ];
    extraConfigLua = ''
      require("tmux").setup({
      })
    '';
  };
}
