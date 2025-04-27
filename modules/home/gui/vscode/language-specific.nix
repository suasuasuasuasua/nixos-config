{ lib, pkgs, ... }:
with lib;
{
  # enabled by default
  bash = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Bash";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        mads-hartmann.bash-ide-vscode
      ];
    };
  };
  c_cplusplus = {
    enable = mkEnableOption "Enable C/C++";
    extensions = mkOption {
      type = with types; listOf package;
      default =
        with pkgs.vscode-extensions;
        [
          ms-vscode.cmake-tools
          ms-vscode.makefile-tools
        ]
        ++ lib.optional pkgs.stdenv.isLinux pkgs.vscode-extensions.cpptools;
    };
  };
  java = {
    enable = mkEnableOption "Enable Java";
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        redhat.java
      ];
    };
  };
  # enabled by default
  just = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Typst";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        nefrob.vscode-just-syntax
      ];
    };
  };
  latex = {
    enable = mkEnableOption "Enable LaTeX";
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        james-yu.latex-workshop
        valentjn.vscode-ltex # Spell-check (NOTE: "ltex plus" and harper not in nixpkgs yet)
      ];
    };
  };
  # enabled by default
  markdown = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Markdown";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        davidanson.vscode-markdownlint
        valentjn.vscode-ltex # Spell-check (NOTE: "ltex plus" and harper not in nixpkgs yet)
      ];
    };
  };
  # enabled by default
  nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Nix";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
  };
  # enabled by default
  python = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        # Python
        ms-python.black-formatter
        ms-python.python
        # Jupyter
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-slideshow
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
      ];
    };
  };
  # enabled by default
  typst = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Typst";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        myriad-dreamin.tinymist
        valentjn.vscode-ltex # Spell-check (NOTE: "ltex plus" and harper not in nixpkgs yet)
      ];
    };
  };
  # enabled by default
  yaml = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable YAML";
    };
    extensions = mkOption {
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        redhat.vscode-yaml
      ];
    };
  };
}
