{pkgs,...}:
{
  programs.nixvim = {
    plugins.tmux-navigator = {
      enable = true;
    };

    extraPlugins = with pkgs; [
      vimPlugins.tmux
    ];
    extraConfigLua = ''
      require("tmux").setup({
      })
    '';
  };
}
