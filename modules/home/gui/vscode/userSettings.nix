{ lib, pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  sourceControl = {
    "git.confirmSync" = false;
    "git.blame.editorDecoration.enabled" = true;
  };
  userInterface = {
    "chat.commandCenter.enabled" = false;
    "editor.minimap.enabled" = false;
    "editor.rulers" = [
      80
      81
    ];
    "editor.fontFamily" =
      with pkgs;
      if stdenv.isDarwin then
        ''
          Menlo, Monaco, 'Courier New', monospace
        ''
      else
        ''
          'JetBrainsMono Nerd Font', Consolas, 'Droid Sans Mono', monospace
        '';
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "window.autoDetectColorScheme" = true;
    "window.commandCenter" = false;
    "window.menuBarVisibility" = "compact";
    "window.newWindowProfile" = "Default";
    "window.titleBarStyle" = "custom";
    "workbench.layoutControl.enabled" = false;
  };
  vimSettings = {
    vim = {
      "cursorStylePerMode.normal" = "block";
      "cursorStylePerMode.replace" = "underline";
      "cursorStylePerMode.visual" = "underline";
      "cursorStylePerMode.visualblock" = "underline";
      "cursorStylePerMode.visualline" = "underline";
      foldfix = true;
      handleKeys = {
        # disable the ctrl+b and ctrl+f movement
        "<C-b>" = false;
        "<C-f>" = false;
      };
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

  default = lib.mergeAttrsList [
    sourceControl
    userInterface
    vimSettings
  ];
}
