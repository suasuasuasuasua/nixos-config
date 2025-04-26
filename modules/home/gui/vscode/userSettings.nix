{ lib, pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  sourceControl = {
    "git.confirmSync" = false;
  };
  userInterface = {
    "chat.commandCenter.enabled" = false;
    "editor.minimap.enabled" = false;
    "editor.rulers" = [
      80
      81
    ];
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "window.autoDetectColorScheme" = true;
    "window.commandCenter" = false;
    "window.newWindowProfile" = "Default";
    "workbench.layoutControl.enabled" = false;
  };
  jupyterSettings = {
    "jupyter.askForKernelRestart" = false;
  };
  nixSettings = {
    "nixformatterPath" = "nixfmt";
    "nix.enableLanguageServer" = true;
    "nix.serverSettings" = {
      "nil.formatting.command" = [ "nixfmt" ];
    };
  };
  typescriptSettings = {
    "typescript.preferences.importModuleSpecifier" = "non-relative";
  };
  # combine the language settings
  languageSettings = jupyterSettings // nixSettings // typescriptSettings;

  vimSettings = {
    vim = {
      "cursorStylePerMode.normal" = "block";
      "cursorStylePerMode.replace" = "underline";
      "cursorStylePerMode.visual" = "underline";
      "cursorStylePerMode.visualblock" = "underline";
      "cursorStylePerMode.visualline" = "underline";
      foldfix = true;
      "highlightedyank.textColor" = "'blue'";
      insertModeKeyBindings = [
        {
          after = [
            "<Esc>"
          ];
          before = [
            "j"
            "k"
          ];
        }
      ];
      joinspaces = false;
      leader = "\\ ";
      normalModeKeyBindings = [
        {
          before = [
            "c"
            "d"
          ];
          commands = [
            {
              command = "editor.action.rename";
            }
          ];
        }
      ];
    };
  };
in
lib.mkOption {
  inherit (jsonFormat) type;

  default = sourceControl // userInterface // languageSettings // vimSettings;
}
