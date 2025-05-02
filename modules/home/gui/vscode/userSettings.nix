{ lib, pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isLinux;
in
lib.mkOption {
  inherit (jsonFormat) type;

  default = {
    "chat.commandCenter.enabled" = false;
    "direnv.restart.automatic" = true;
    "editor.minimap.enabled" = false;
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
    "editor.formatOnPaste" = true;
    "editor.formatOnSave" = true;
    "editor.rulers" = [
      80
      81
    ];
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "extensions.autoUpdate" = false;
    "files.autoSave" = "afterDelay";
    "git.autofetch" = true;
    "git.confirmSync" = false;
    "git.blame.editorDecoration.enabled" = true;
    "pdf-preview.default.scale" = "page-fit";
    "telemetry.feedback.enabled" = false;
    "telemetry.telemetryLevel" = "off";
    "vim.cursorStylePerMode.normal" = "block";
    "vim.cursorStylePerMode.replace" = "underline";
    "vim.cursorStylePerMode.visual" = "underline";
    "vim.cursorStylePerMode.visualblock" = "underline";
    "vim.cursorStylePerMode.visualline" = "underline";
    "vim.foldfix" = true;
    "vim.handleKeys" = {
      # disable the ctrl+b and ctrl+f movement
      "<C-b>" = false;
      "<C-f>" = false;
    };
    "vim.highlightedyank.textColor" = "'blue'";
    "vim.insertModeKeyBindings" = [
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
    "vim.joinspaces" = false;
    "vim.leader" = "\\ ";
    "vim.normalModeKeyBindings" = [
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
    "window.autoDetectColorScheme" = true;
    "window.commandCenter" = false;
    "window.newWindowProfile" = "Default";
    "window.titleBarStyle" = "custom";
    "workbench.layoutControl.enabled" = false;
    "workbench.reduceMotion" = "on";
    "workbench.startupEditor" = "none";
    "window.menuBarVisibility" = mkIf isLinux "compact";
    "workbench.welcomePage.extraAnnouncements" = false;
    "workbench.welcomePage.walkthroughs.openOnInstall" = false;
  };
}
