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

  bottomPanelBindings = [
    {
      key = "ctrl+cmd+j";
      command = "workbench.action.togglePanel";
    }
    {
      key = "cmd+j";
      command = "-workbench.action.togglePanel";
    }
  ];

  editorManipulationBindings = [
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
      key = "ctrl+alt+h";
      command = "workbench.action.moveEditorLeftInGroup";
    }
    {
      key = "cmd+k shift+cmd+left";
      command = "-workbench.action.moveEditorLeftInGroup";
    }
    {
      key = "ctrl+alt+l";
      command = "workbench.action.moveEditorRightInGroup";
    }
    {
      key = "cmd+k shift+cmd+right";
      command = "-workbench.action.moveEditorRightInGroup";
    }
  ];

  editorNavigationBindings = [
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
      key = "alt+h";
      command = "workbench.action.previousEditorInGroup";
    }
    {
      key = "cmd+k alt+cmd+left";
      command = "-workbench.action.previousEditorInGroup";
    }
    {
      key = "alt+l";
      command = "workbench.action.nextEditorInGroup";
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
  ];

  explorerBindings = [
    {
      key = "shift+cmd+c";
      command = "workbench.files.action.collapseExplorerFolders";
    }
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
  ];

  finderBindings = [
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
  ];

  jupyterBindings = [
    {
      key = "u";
      command = "undo";
      when = "notebookEditorFocused && !inputFocus";
    }
    {
      key = "z";
      command = "-undo";
      when = "notebookEditorFocused && !inputFocus";
    }
  ];
  languageBindings = jupyterBindings;

  previewerBindings = [
    {
      key = "ctrl+cmd+v";
      command = "markdown.showPreviewToSide";
      when = "!notebookEditorFocused && editorLangId == 'markdown'";
    }
    {
      key = "cmd+k v";
      command = "-markdown.showPreviewToSide";
      when = "!notebookEditorFocused && editorLangId == 'markdown'";
    }
    {
      key = "shift+cmd+v";
      command = "-markdown.showPreview";
      when = "!notebookEditorFocused && editorLangId == 'markdown'";
    }
    {
      key = "ctrl+cmd+v";
      command = "livePreview.start.internalPreview.atFile";
      when = "editorLangId == 'html'";
    }
  ];

  sourceControlBindings = [
    {
      key = "shift+cmd+g";
      command = "workbench.view.scm";
      when = "workbench.scm.active";
    }
    {
      key = "ctrl+shift+g";
      command = "-workbench.view.scm";
      when = "workbench.scm.active";
    }
  ];

  terminalBindings = [
    {
      key = "ctrl+cmd+k";
      command = "workbench.action.terminal.toggleTerminal";
      when = "terminal.active";
    }
    {
      key = "ctrl+`";
      command = "-workbench.action.terminal.toggleTerminal";
      when = "terminal.active";
    }
  ];

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
    ++ languageBindings
    ++ previewerBindings
    ++ sourceControlBindings
    ++ terminalBindings
    ++ vimBindings;
}
