{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.custom.home.cli.zsh;
in
{
  options.custom.home.cli.zsh = {
    enable = lib.mkEnableOption "Enable ZSH shell config";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      autocd = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        c = "clear";
        lg = "lazygit";
        lc = "nvim leetcode.nvim";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      localVariables = {
        ZVM_VI_ESCAPE_BINDKEY = "jk";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
        theme = "frisk";
      };
      plugins = with pkgs; [
        {
          name = "vi-mode";
          src = zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };
  };
}
