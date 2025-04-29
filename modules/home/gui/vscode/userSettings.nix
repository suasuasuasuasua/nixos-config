{ lib, pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

in
lib.mkOption {
  inherit (jsonFormat) type;

  default = {
    "chat.commandCenter.enabled" = false;
    "direnv.restart.automatic" = true;
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
    "git.confirmSync" = false;
    "git.blame.editorDecoration.enabled" = true;
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
    "window.menuBarVisibility" = "compact";
    "window.newWindowProfile" = "Default";
    "window.titleBarStyle" = "custom";
    "workbench.layoutControl.enabled" = false;
    "workbench.welcomePage.walkthroughs.openOnInstall" = true;
    "workbench.welcomePage.extraAnnouncements" = true;
    "workbench.startupEditor" = "none";
  };
}
