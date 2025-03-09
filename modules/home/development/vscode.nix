{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.development.vscode;
in
{
  options.home.development.vscode = {
    enable = lib.mkEnableOption "Enable Visual Studio Code";
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      # # get and update packages through nixpkgs
      # mutableExtensionsDir = false;
      extensions = with pkgs.vscode-extensions; [
        # General
        codezombiech.gitignore
        gruntfuggly.todo-tree
        vscodevim.vim
        waderyan.gitblame

        # Langs
        ms-python.python

        # Nix Dev
        jnoortheen.nix-ide
        mkhl.direnv

        # Remote
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-wsl
      ];
      userSettings = {
        # vim setup
        vim = {
          "cursorStylePerMode.normal" = "block";
          "cursorStylePerMode.replace" = "underline";
          "cursorStylePerMode.visual" = "underline";
          "cursorStylePerMode.visualblock" = "underline";
          "cursorStylePerMode.visualline" = "underline";
          "foldfix" = true;
          "highlightedyank.textColor" = "'blue'";
          "insertModeKeyBindings" = [
            {
              "after" = [
                "<Esc>"
              ];
              "before" = [
                "j"
                "k"
              ];
            }
          ];
          "joinspaces" = false;
          "leader" = "\\ ";
          "normalModeKeyBindings" = [
            {
              "before" = [
                "c"
                "d"
              ];
              "commands" = [
                {
                  "command" = "editor.action.rename";
                }
              ];
            }
          ];
        };
      };
    };
  };
}
