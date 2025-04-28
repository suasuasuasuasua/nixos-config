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
in
with lib;
{
  data-science = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Data Science Profile";
    };
    languages = mkOption {
      type = with types; listOf str;
      default = [
        "python"
        "spell"
        "typst"
      ];
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = [ ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [ ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = { };
    };
  };
}
