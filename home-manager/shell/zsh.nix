{
  config,
  pkgs,
  ...
}: {
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
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra =
      /*
      bash
      */
      ''
        export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
      '';
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
}
