{ lib, pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };
  keybindingSubmodule =
    with lib.types;
    listOf (
      types.submodule {
        options = {
          key = lib.mkOption {
            type = types.str;
            example = "ctrl+c";
            description = "The key or key-combination to bind.";
          };

          command = lib.mkOption {
            type = types.str;
            example = "editor.action.clipboardCopyAction";
            description = "The VS Code command to execute.";
          };

          when = lib.mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "textInputFocus";
            description = "Optional context filter.";
          };

          # https://code.visualstudio.com/docs/getstarted/keybindings#_command-arguments
          args = lib.mkOption {
            type = types.nullOr jsonFormat.type;
            default = null;
            example = {
              direction = "up";
            };
            description = "Optional arguments for a command.";
          };
        };
      }
    );

  bottomPanelBindings =
    with lib;
    with pkgs;
    (
      optionals stdenv.isDarwin [
        {
          key = "ctrl+cmd+j";
          command = "workbench.action.togglePanel";
        }
        {
          key = "cmd+j";
          command = "-workbench.action.togglePanel";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "ctrl+alt+j";
          command = "workbench.action.togglePanel";
        }
        {
          key = "ctrl+alt+j";
          command = "-workbench.action.togglePanel";
        }
      ]
    );
  editorManipulationBindings =
    with lib;
    with pkgs;
    (
      [
        {
          key = "ctrl+alt+h";
          command = "workbench.action.moveEditorLeftInGroup";
        }
        {
          key = "ctrl+alt+l";
          command = "workbench.action.moveEditorRightInGroup";
        }
      ]
      ++ optionals stdenv.isDarwin [
        {
          key = "cmd+4";
          command = "workbench.action.closeActiveEditor";
        }
        {
          key = "cmd+w";
          command = "-workbench.action.closeActiveEditor";
        }
        {
          key = "shift+cmd+b";
          command = "workbench.action.toggleAuxiliaryBar";
        }
        {
          key = "shift+cmd+a";
          command = "workbench.action.toggleActivityBarVisibility";
        }
        {
          key = "shift+cmd+=";
          command = "-workbench.action.zoomIn";
        }
        {
          key = "shift+cmd+-";
          command = "-workbench.action.zoomOut";
        }
        {
          key = "cmd+0";
          command = "workbench.action.zoomReset";
        }
        {
          key = "cmd+numpad0";
          command = "-workbench.action.zoomReset";
        }
        {
          key = "shift+cmd+j";
          command = "workbench.action.moveActiveEditorGroupDown";
        }
        {
          key = "cmd+k down";
          command = "-workbench.action.moveActiveEditorGroupDown";
        }
        {
          key = "shift+cmd+h";
          command = "workbench.action.moveActiveEditorGroupLeft";
        }
        {
          key = "cmd+k left";
          command = "-workbench.action.moveActiveEditorGroupLeft";
        }
        {
          key = "shift+cmd+l";
          command = "workbench.action.moveActiveEditorGroupRight";
        }
        {
          key = "cmd+k right";
          command = "-workbench.action.moveActiveEditorGroupRight";
        }
        {
          key = "shift+cmd+k";
          command = "workbench.action.moveActiveEditorGroupUp";
        }
        {
          key = "cmd+k up";
          command = "-workbench.action.moveActiveEditorGroupUp";
        }
        {
          key = "ctrl+shift+cmd+k";
          command = "workbench.action.moveEditorToAboveGroup";
        }
        {
          key = "ctrl+shift+cmd+j";
          command = "workbench.action.moveEditorToBelowGroup";
        }
        {
          key = "ctrl+shift+cmd+h";
          command = "workbench.action.moveEditorToLeftGroup";
        }
        {
          key = "ctrl+shift+cmd+l";
          command = "workbench.action.moveEditorToRightGroup";
        }
        {
          key = "cmd+k shift+cmd+left";
          command = "-workbench.action.moveEditorLeftInGroup";
        }
        {
          key = "cmd+k shift+cmd+right";
          command = "-workbench.action.moveEditorRightInGroup";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "ctrl+4";
          command = "workbench.action.closeActiveEditor";
        }
        {
          key = "ctrl+w";
          command = "-workbench.action.closeActiveEditor";
        }
        {
          key = "shift+ctrl+b";
          command = "workbench.action.toggleAuxiliaryBar";
        }
        {
          key = "shift+ctrl+a";
          command = "workbench.action.toggleActivityBarVisibility";
        }
        {
          key = "shift+ctrl+=";
          command = "-workbench.action.zoomIn";
        }
        {
          key = "shift+ctrl+-";
          command = "-workbench.action.zoomOut";
        }
        {
          key = "ctrl+0";
          command = "workbench.action.zoomReset";
        }
        {
          key = "ctrl+numpad0";
          command = "-workbench.action.zoomReset";
        }
        {
          key = "shift+ctrl+j";
          command = "workbench.action.moveActiveEditorGroupDown";
        }
        {
          key = "ctrl+k down";
          command = "-workbench.action.moveActiveEditorGroupDown";
        }
        {
          key = "shift+ctrl+h";
          command = "workbench.action.moveActiveEditorGroupLeft";
        }
        {
          key = "ctrl+k left";
          command = "-workbench.action.moveActiveEditorGroupLeft";
        }
        {
          key = "shift+ctrl+l";
          command = "workbench.action.moveActiveEditorGroupRight";
        }
        {
          key = "ctrl+k right";
          command = "-workbench.action.moveActiveEditorGroupRight";
        }
        {
          key = "shift+ctrl+k";
          command = "workbench.action.moveActiveEditorGroupUp";
        }
        {
          key = "ctrl+k up";
          command = "-workbench.action.moveActiveEditorGroupUp";
        }
        {
          key = "ctrl+shift+alt+k";
          command = "workbench.action.moveEditorToAboveGroup";
        }
        {
          key = "ctrl+shift+alt+j";
          command = "workbench.action.moveEditorToBelowGroup";
        }
        {
          key = "ctrl+shift+alt+h";
          command = "workbench.action.moveEditorToLeftGroup";
        }
        {
          key = "ctrl+shift+alt+l";
          command = "workbench.action.moveEditorToRightGroup";
        }
        {
          key = "ctrl+k shift+ctrl+left";
          command = "-workbench.action.moveEditorLeftInGroup";
        }
        {
          key = "ctrl+k shift+ctrl+right";
          command = "-workbench.action.moveEditorRightInGroup";
        }
      ]
    );
  editorNavigationBindings =
    with lib;
    with pkgs;
    (
      [
        {
          key = "alt+h";
          command = "workbench.action.previousEditorInGroup";
        }
        {
          key = "alt+l";
          command = "workbench.action.nextEditorInGroup";
        }
        {
          key = "ctrl+alt+p";
          command = "workbench.action.quickOpen";
        }
        {
          "key" = "ctrl+n";
          "command" = "workbench.action.quickOpenSelectNext";
          "when" = "inQuickOpen";
        }
        {
          "key" = "ctrl+p";
          "command" = "workbench.action.quickOpenSelectPrevious";
          "when" = "inQuickOpen";
        }
      ]
      ++ optionals stdenv.isDarwin [
        {
          key = "cmd+h";
          command = "workbench.action.focusLeftGroup";
        }
        {
          key = "cmd+k cmd+left";
          command = "-workbench.action.focusLeftGroup";
        }
        {
          key = "cmd+l";
          command = "workbench.action.focusRightGroup";
        }
        {
          key = "cmd+k cmd+right";
          command = "-workbench.action.focusRightGroup";
        }
        {
          key = "cmd+k";
          command = "workbench.action.focusAboveGroup";
        }
        {
          key = "cmd+k cmd+up";
          command = "-workbench.action.focusAboveGroup";
        }
        {
          key = "cmd+j";
          command = "workbench.action.focusBelowGroup";
        }
        {
          key = "cmd+k cmd+down";
          command = "-workbench.action.focusBelowGroup";
        }
        {
          key = "cmd+k alt+cmd+left";
          command = "-workbench.action.previousEditorInGroup";
        }
        {
          key = "cmd+k alt+cmd+right";
          command = "-workbench.action.nextEditorInGroup";
        }
        {
          key = "ctrl+cmd+e";
          command = "workbench.action.focusActiveEditorGroup";
        }
        {
          key = "ctrl+cmd+b";
          command = "workbench.action.focusSideBar";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "ctrl+h";
          command = "workbench.action.focusLeftGroup";
        }
        {
          key = "ctrl+k ctrl+left";
          command = "-workbench.action.focusLeftGroup";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.focusRightGroup";
        }
        {
          key = "ctrl+k ctrl+right";
          command = "-workbench.action.focusRightGroup";
        }
        {
          key = "ctrl+k";
          command = "workbench.action.focusAboveGroup";
        }
        {
          key = "ctrl+k ctrl+up";
          command = "-workbench.action.focusAboveGroup";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.focusBelowGroup";
        }
        {
          key = "ctrl+k ctrl+down";
          command = "-workbench.action.focusBelowGroup";
        }
        {
          key = "ctrl+k alt+ctrl+left";
          command = "-workbench.action.previousEditorInGroup";
        }
        {
          key = "ctrl+k alt+ctrl+right";
          command = "-workbench.action.nextEditorInGroup";
        }
        {
          key = "ctrl+alt+e";
          command = "workbench.action.focusActiveEditorGroup";
        }
        {
          key = "ctrl+alt+b";
          command = "workbench.action.focusSideBar";
        }
      ]
    );
  explorerBindings =
    with lib;
    with pkgs;
    (
      [
        {
          key = "shift+j";
          command = "list.expandSelectionDown";
          when = "listFocus && listSupportsMultiselect && !inputFocus";
        }
        {
          key = "shift+down";
          command = "-list.expandSelectionDown";
          when = "listFocus && listSupportsMultiselect && !inputFocus";
        }
        {
          key = "shift+k";
          command = "list.expandSelectionUp";
          when = "listFocus && listSupportsMultiselect && !inputFocus";
        }
        {
          key = "shift+up";
          command = "-list.expandSelectionUp";
          when = "listFocus && listSupportsMultiselect && !inputFocus";
        }
      ]
      ++ optionals stdenv.isDarwin [
        {
          key = "shift+cmd+c";
          command = "workbench.files.action.collapseExplorerFolders";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "shift+ctrl+c";
          command = "workbench.files.action.collapseExplorerFolders";
        }
      ]
    );
  finderBindings =
    with lib;
    with pkgs;
    (
      optionals stdenv.isDarwin [
        {
          key = "shift+cmd+f";
          command = "-workbench.action.findInFiles";
        }
        {
          key = "shift+cmd+f";
          command = "-workbench.action.terminal.searchWorkspace";
          when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
        }
        {
          key = "shift+cmd+f";
          command = "-workbench.view.search";
          when = "workbench.view.search.active && neverMatch =~ /doesNotMatch/";
        }
        {
          key = "shift+cmd+f";
          command = "workbench.view.search.focus";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "shift+ctrl+f";
          command = "-workbench.action.findInFiles";
        }
        {
          key = "shift+ctrl+f";
          command = "-workbench.action.terminal.searchWorkspace";
          when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
        }
        {
          key = "shift+ctrl+f";
          command = "-workbench.view.search";
          when = "workbench.view.search.active && neverMatch =~ /doesNotMatch/";
        }
        {
          key = "shift+ctrl+f";
          command = "workbench.view.search.focus";
        }
      ]
    );
  previewerBindings =
    with lib;
    with pkgs;
    (
      optionals stdenv.isDarwin [
        {
          key = "ctrl+cmd+v";
          command = "livePreview.start.internalPreview.atFile";
          when = "editorLangId == 'html'";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "ctrl+alt+v";
          command = "livePreview.start.internalPreview.atFile";
          when = "editorLangId == 'html'";
        }
      ]
    );
  sourceControlBindings =
    with lib;
    with pkgs;
    (
      optionals stdenv.isDarwin [
        {
          key = "shift+cmd+g";
          command = "workbench.view.scm";
          when = "workbench.scm.active";
        }
        {
          key = "shift+cmd+g";
          command = "-workbench.view.scm";
          when = "workbench.scm.active";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "shift+ctrl+g";
          command = "workbench.view.scm";
          when = "workbench.scm.active";
        }
        {
          key = "shift+ctrl+g";
          command = "-workbench.view.scm";
          when = "workbench.scm.active";
        }
      ]
    );
  terminalBindings =
    with lib;
    with pkgs;
    (
      [
        {
          key = "ctrl+`";
          command = "-workbench.action.terminal.toggleTerminal";
          when = "terminal.active";

        }
      ]
      ++ optionals stdenv.isDarwin [
        {
          key = "ctrl+cmd+k";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }
      ]
      ++ optionals stdenv.isLinux [
        {
          key = "ctrl+alt+k";
          command = "workbench.action.terminal.toggleTerminal";
          when = "terminal.active";
        }
      ]
    );
  vimBindings = [
    {
      key = "ctrl+h";
      command = "-extension.vim_ctrl+h";
      when = "editorTextFocus && vim.active && vim.use<C-h> && !inDebugRepl";
    }
    {
      key = "ctrl+l";
      command = "-extension.vim_navigateCtrlL";
      when = "editorTextFocus && vim.active && vim.use<C-l> && !inDebugRepl";
    }
  ];
in
lib.mkOption {
  type = keybindingSubmodule;
  default =
    bottomPanelBindings
    ++ editorManipulationBindings
    ++ editorNavigationBindings
    ++ explorerBindings
    ++ finderBindings
    ++ previewerBindings
    ++ sourceControlBindings
    ++ terminalBindings
    ++ vimBindings;
}
