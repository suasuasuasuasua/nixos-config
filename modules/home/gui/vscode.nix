{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.vscode;
in
{
  options.home.gui.vscode = {
    enable = lib.mkEnableOption "Enable Visual Studio Code";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # General
        vscodevim.vim
        gruntfuggly.todo-tree
        codezombiech.gitignore

        # Remote
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-wsl
        ms-vscode-remote.remote-containers

        # Nix Dev
        jnoortheen.nix-ide
        mkhl.direnv
      ];
    };
  };
}
