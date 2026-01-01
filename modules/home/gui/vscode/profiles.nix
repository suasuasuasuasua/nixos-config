{
  jsonFormat,
  keybindingSubmodule,
  lib,
  options,
  pkgs,
  ...
}:
let
  opts = options.custom.home.gui.vscode;

  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) bool listOf package;

  # Only choose one of the languages specified in the language configurations
  enumLanguages =
    let
      inherit (lib) attrNames;
      inherit (lib.types) listOf enum;
    in
    listOf (enum (attrNames opts.language-configurations));
in
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
        "toml"
        "typst"
        "yaml"
      ];
    };
    extensions = mkOption {
      type = listOf package;
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
      type = bool;
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
        "toml"
        "typst"
        "yaml"
      ];
    };
    extensions = mkOption {
      type = listOf package;
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
  "Flutter Development" = {
    enable = mkEnableOption "Enable Flutter Development Profile";
    languages = mkOption {
      type = enumLanguages;
      default = [
        "dart"
        "just"
        "markdown"
        "python"
        "spell"
        "toml"
        "typst"
        "yaml"
      ];
    };
    extensions = mkOption {
      type = listOf package;
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
  "Markup" = {
    enable = mkOption {
      type = bool;
      default = true;
      description = "Enable Markup Profile";
    };
    languages = mkOption {
      type = enumLanguages;
      default = [
        "markdown"
        "spell"
        "typst"
      ];
    };
    extensions = mkOption {
      type = listOf package;
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
      type = listOf package;
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
  "Web Development" = {
    enable = mkEnableOption "Enable Web Development Profile";
    languages = mkOption {
      type = enumLanguages;
      default = [
        "css"
        "javascript"
        "just"
        "html"
        "markdown"
        "spell"
        "toml"
        "typescript"
        "yaml"
      ];
    };
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        unifiedjs.vscode-mdx # markdown with react
        ms-vscode.live-server # live preview for web pages
      ];
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
