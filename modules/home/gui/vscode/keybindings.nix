{
  keybindingSubmodule,
  lib,
  pkgs,
  ...
}:
lib.mkOption {
  type = keybindingSubmodule;
  default =
    let
      inherit (pkgs.stdenv) isDarwin;

      mod_ctrl = if isDarwin then "cmd" else "ctrl";
      mod_alt = if isDarwin then "cmd" else "alt";
    in
    # bottom panel bindings
    [
      {
        key = "ctrl+${mod_ctrl}+j";
        command = "workbench.action.togglePanel";
      }
    ]
    # editor manipulation bindings
    ++ [
      {
        key = "ctrl+y";
        command = "acceptSelectedSuggestion";
        when = "suggestWidgetHasFocusedSuggestion && suggestWidgetVisible && suggestionMakesTextEdit && textInputFocus";
      }
      {
        key = "ctrl+y";
        command = "editor.action.inlineSuggest.commit";
        when = "inlineEditIsVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible";
      }
      {
        key = "ctrl+y";
        command = "editor.action.inlineSuggest.commit";
        when = "inInlineEditsPreviewEditor";
      }
      {
        key = "ctrl+alt+h";
        command = "workbench.action.moveEditorLeftInGroup";
      }
      {
        key = "ctrl+alt+l";
        command = "workbench.action.moveEditorRightInGroup";
      }
      {
        key = "${mod_ctrl}+4";
        command = "workbench.action.closeActiveEditor";
      }
      {
        key = "${mod_ctrl}+w";
        command = "-workbench.action.closeActiveEditor";
      }
      {
        key = "shift+${mod_ctrl}+b";
        command = "workbench.action.toggleAuxiliaryBar";
      }
      {
        key = "shift+${mod_ctrl}+a";
        command = "workbench.action.toggleActivityBarVisibility";
      }
      {
        key = "shift+${mod_ctrl}+=";
        command = "-workbench.action.zoomIn";
      }
      {
        key = "shift+${mod_ctrl}+-";
        command = "-workbench.action.zoomOut";
      }
      {
        key = "${mod_ctrl}+0";
        command = "workbench.action.zoomReset";
      }
      {
        key = "${mod_ctrl}+numpad0";
        command = "-workbench.action.zoomReset";
      }
      {
        key = "shift+${mod_ctrl}+j";
        command = "workbench.action.moveActiveEditorGroupDown";
      }
      {
        key = "${mod_ctrl}+k down";
        command = "-workbench.action.moveActiveEditorGroupDown";
      }
      {
        key = "shift+${mod_ctrl}+h";
        command = "workbench.action.moveActiveEditorGroupLeft";
      }
      {
        key = "${mod_ctrl}+k left";
        command = "-workbench.action.moveActiveEditorGroupLeft";
      }
      {
        key = "shift+${mod_ctrl}+l";
        command = "workbench.action.moveActiveEditorGroupRight";
      }
      {
        key = "${mod_ctrl}+k right";
        command = "-workbench.action.moveActiveEditorGroupRight";
      }
      {
        key = "shift+${mod_ctrl}+k";
        command = "workbench.action.moveActiveEditorGroupUp";
      }
      {
        key = "${mod_ctrl}+k up";
        command = "-workbench.action.moveActiveEditorGroupUp";
      }
      {
        key = "ctrl+shift+${mod_alt}+k";
        command = "workbench.action.moveEditorToAboveGroup";
      }
      {
        key = "ctrl+shift+${mod_alt}+j";
        command = "workbench.action.moveEditorToBelowGroup";
      }
      {
        key = "ctrl+shift+${mod_alt}+h";
        command = "workbench.action.moveEditorToLeftGroup";
      }
      {
        key = "ctrl+shift+${mod_alt}+l";
        command = "workbench.action.moveEditorToRightGroup";
      }
      {
        key = "${mod_ctrl}+k shift+${mod_ctrl}+left";
        command = "-workbench.action.moveEditorLeftInGroup";
      }
      {
        key = "${mod_ctrl}+k shift+${mod_ctrl}+right";
        command = "-workbench.action.moveEditorRightInGroup";
      }
    ]
    # editor navigation bindings
    ++ [
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
      {
        key = "${mod_ctrl}+h";
        command = "workbench.action.focusLeftGroup";
      }
      {
        key = "${mod_ctrl}+k ${mod_ctrl}+left";
        command = "-workbench.action.focusLeftGroup";
      }
      {
        key = "${mod_ctrl}+l";
        command = "workbench.action.focusRightGroup";
      }
      {
        key = "${mod_ctrl}+k ${mod_ctrl}+right";
        command = "-workbench.action.focusRightGroup";
      }
      {
        key = "${mod_ctrl}+k";
        command = "workbench.action.focusAboveGroup";
      }
      {
        key = "${mod_ctrl}+k ${mod_ctrl}+up";
        command = "-workbench.action.focusAboveGroup";
      }
      {
        key = "${mod_ctrl}+j";
        command = "workbench.action.focusBelowGroup";
      }
      {
        key = "${mod_ctrl}+k ${mod_ctrl}+down";
        command = "-workbench.action.focusBelowGroup";
      }
      {
        key = "${mod_ctrl}+k alt+${mod_ctrl}+left";
        command = "-workbench.action.previousEditorInGroup";
      }
      {
        key = "${mod_ctrl}+k alt+${mod_ctrl}+right";
        command = "-workbench.action.nextEditorInGroup";
      }
      {
        key = "ctrl+${mod_alt}+e";
        command = "workbench.action.focusActiveEditorGroup";
      }
      {
        key = "ctrl+${mod_alt}+b";
        command = "workbench.action.focusSideBar";
      }
    ]
    ++ [
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
      {
        key = "shift+${mod_ctrl}+c";
        command = "workbench.files.action.collapseExplorerFolders";
      }
    ]
    # finder keybindings
    ++ [
      {
        key = "shift+${mod_ctrl}+f";
        command = "-workbench.action.findInFiles";
      }
      {
        key = "shift+${mod_ctrl}+f";
        command = "-workbench.action.terminal.searchWorkspace";
        when = "terminalFocus && terminalProcessSupported && terminalTextSelected";
      }
      {
        key = "shift+${mod_ctrl}+f";
        command = "-workbench.view.search";
        when = "workbench.view.search.active && neverMatch =~ /doesNotMatch/";
      }
      {
        key = "shift+${mod_ctrl}+f";
        command = "workbench.view.search.focus";
      }
    ]
    # previewer bindings
    ++ [
      {
        key = "ctrl+${mod_alt}+v";
        command = "livePreview.start.internalPreview.atFile";
        when = "editorLangId == 'html'";
      }
    ]
    # source control bindings
    ++ [
      {
        key = "shift+${mod_ctrl}+g";
        command = "workbench.view.scm";
        when = "workbench.scm.active";
      }
      {
        key = "shift+${mod_ctrl}+g";
        command = "-workbench.view.scm";
        when = "workbench.scm.active";
      }
    ]
    # terminal bindings
    ++ [
      {
        key = "ctrl+`";
        command = "-workbench.action.terminal.toggleTerminal";
        when = "terminal.active";

      }
      {
        key = "ctrl+${mod_alt}+k";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
    ]
    # vim bindings
    ++ [
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
}
