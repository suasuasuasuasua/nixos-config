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
    extensions = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs.vscode-extensions; [
        # General
        codezombiech.gitignore
        esbenp.prettier-vscode
        gruntfuggly.todo-tree
        vscodevim.vim
        waderyan.gitblame

        # Languages (general)
        ms-azuretools.vscode-docker # docker
        ms-toolsai.jupyter # jupyter
        ms-python.python # python
        ms-python.isort # python
        skellock.just # just

        # Nix Dev
        jnoortheen.nix-ide
        mkhl.direnv

        # Remote
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-wsl
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      inherit (cfg) extensions;

      enable = true;
      # get and update packages through nixpkgs ONLY if false
      mutableExtensionsDir = true;
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
