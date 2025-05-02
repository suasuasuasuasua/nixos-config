{
  lib,
  pkgs,
  jsonFormat,
  keybindingSubmodule,
  ...
}:
let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) listOf package;
in
{
  bash = {
    enable = mkEnableOption "Enable Bash";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        mads-hartmann.bash-ide-vscode
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
  c_cplusplus = {
    enable = mkEnableOption "Enable C/C++";
    extensions = mkOption {
      type = listOf package;
      default =
        with pkgs.vscode-extensions;
        [
          ms-vscode.cmake-tools
          ms-vscode.makefile-tools
        ]
        # NOTE: not available for nix-darwin yet...
        # https://github.com/NixOS/nixpkgs/issues/377294
        # https://github.com/nix-community/nix-vscode-extensions/issues/113
        ++ lib.optional pkgs.stdenv.isLinux pkgs.vscode-extensions.ms-vscode.cpptools;
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
  csharp = {
    enable = mkEnableOption "Enable C#";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
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
  common_lisp = {
    enable = mkEnableOption "Enable CommonLisp";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-marketplace; [
        rheller.alive
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [ ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        "redhat.telemetry.enabled" = false;
      };
    };
  };
  css = {
    enable = mkEnableOption "Enable CSS";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        bradlc.vscode-tailwindcss
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
  dart = {
    enable = mkEnableOption "Enable Dart";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        dart-code.dart-code
        dart-code.flutter
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
  go = {
    enable = mkEnableOption "Enable Go";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        golang.go
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
  html = {
    enable = mkEnableOption "Enable html";
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
  java = {
    enable = mkEnableOption "Enable Java";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        redhat.java
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [ ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        "redhat.telemetry.enabled" = false;
      };
    };
  };
  julia = {
    enable = mkEnableOption "Enable Julia";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        julialang.language-julia
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
  just = {
    enable = mkEnableOption "Enable Typst";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        nefrob.vscode-just-syntax
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
  latex = {
    enable = mkEnableOption "Enable LaTeX";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        james-yu.latex-workshop
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
  markdown = {
    enable = mkEnableOption "Enable Markdown";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        davidanson.vscode-markdownlint
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default =
        let
          inherit (lib) optionals;
          inherit (pkgs.stdenv) isDarwin isLinux;
        in
        optionals isDarwin [
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
        ]
        ++ optionals isLinux [
          {
            key = "ctrl+alt+v";
            command = "markdown.showPreviewToSide";
            when = "!notebookEditorFocused && editorLangId == 'markdown'";
          }
          {
            key = "ctrl+k v";
            command = "-markdown.showPreviewToSide";
            when = "!notebookEditorFocused && editorLangId == 'markdown'";
          }
          {
            key = "shift+ctrl+v";
            command = "-markdown.showPreview";
            when = "!notebookEditorFocused && editorLangId == 'markdown'";
          }
        ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        # Multiple choices for configured formatters
        "[markdown]" = {
          "editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
          # "editor.defaultFormatter": "esbenp.prettier-vscode"
        };
        "markdownlint.run" = "onSave";
      };
    };
  };
  nix = {
    enable = mkEnableOption "Enable Nix";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [ ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
            "options" = {
              "nixos" = {
                "expr" = ''
                  (builtins.getFlake ("git+file://" + toString /home/justinhoang/nixos-config)).nixosConfigurations."penguin".options;
                '';
              };
              "darwin" = {
                "expr" = ''
                  (builtins.getFlake ("git+file://" + toString /Users/justinhoang/nixos-config)).darwinConfigurations."mbp3".options;
                '';
              };
              "home-manager" = {
                "expr " = ''
                  (builtins.getFlake ("git+file://" + toString /home/justinhoang/nixos-config)).homeConfigurations."wsl".options;
                '';
              };
            };
          };
        };
      };
    };
  };
  ocaml = {
    enable = mkEnableOption "Enable OCaml";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        ocamllabs.ocaml-platform
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
  python = {
    enable = mkEnableOption "Enable Python";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        # Python
        ms-python.black-formatter
        ms-python.isort
        ms-python.python
        ms-python.pylint
        # Jupyter
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [
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
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        "black-formatter.importStrategy" = "fromEnvironment";
        "jupyter.askForKernelRestart" = false;
        "jupyter.themeMatplotlibPlots" = true;
      };
    };
  };
  r = {
    enable = mkEnableOption "Enable R";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        reditorsupport.r
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
  rust = {
    enable = mkEnableOption "Enable Rust";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
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
  spell = {
    enable = mkEnableOption "Enable Spellcheck [harper]";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-marketplace; [
        elijah-potter.harper
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [ ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        "harper.dialect" = "American";
        "harper.fileDictPath" = ".harper";
        "harper.userDictPath" = "~/.harper";
      };
    };
  };
  swift = {
    enable = mkEnableOption "Enable Swift";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-marketplace; [
        swiftlang.swift-vscode
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
  toml = {
    enable = mkEnableOption "Enable TOML";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        tamasfe.even-better-toml
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
  typescript = {
    enable = mkEnableOption "Enable Typescript";
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
      default = {
        "typescript.preferences.importModuleSpecifier" = "non-relative";
      };
    };
  };
  typst = {
    enable = mkEnableOption "Enable Typst";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        myriad-dreamin.tinymist
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default = [ ];
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        "tinymist.formatterMode" = "typstyle";
        "tinymist.preview.invertColors" = "auto";
      };
    };
  };
  yaml = {
    enable = mkEnableOption "Enable YAML";
    extensions = mkOption {
      type = listOf package;
      default = with pkgs.vscode-extensions; [
        redhat.vscode-yaml
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
