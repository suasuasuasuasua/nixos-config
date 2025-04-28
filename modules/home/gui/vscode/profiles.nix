{
  options,
  lib,
  pkgs,
  ...
}:
let
  opts = options.home.gui.vscode;

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

  # Only choose one of the languages specified in the language configurations
  enumLanguages = with lib; with lib.types; listOf (enum (attrNames opts.language-configurations));
in
with lib;
{
  "Data Science" = {
    enable = mkEnableOption "Enable Data Science Profile";
    languages = mkOption {
      type = enumLanguages;
      default = [
        "just"
        "markdown"
        "python"
        "spell"
        "typst"
        "yaml"
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
  default = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Default Profile (default slim)";
    };
    languages = mkOption {
      type = enumLanguages;
      default = [
        "bash"
        "just"
        "markdown"
        "nix"
        "python"
        "spell"
        "typst"
        "yaml"
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
  "Maximal" = {
    enable = mkEnableOption "Enable All Profile (all languages)";
    languages = mkOption {
      type = enumLanguages;
      default = lib.attrNames opts.language-configurations;
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
