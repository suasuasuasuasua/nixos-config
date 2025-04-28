{ lib, pkgs, ... }:
with lib;
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
{
  bash = {
    enable = mkEnableOption "Enable Bash";
    extensions = mkOption {
      type = with types; listOf package;
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
      type = with types; listOf package;
      default =
        with pkgs.vscode-extensions;
        [
          ms-vscode.cmake-tools
          ms-vscode.makefile-tools
        ]
        ++ (with pkgs.vscode-marketplace; [
          # # NOTE: not available for nix-darwin yet...
          # # https://github.com/NixOS/nixpkgs/issues/377294
          # # https://github.com/nix-community/nix-vscode-extensions/issues/113
          ms-vscode.cpp-tools
        ]);
      # ++ lib.optional pkgs.stdenv.isLinux pkgs.vscode-extensions.ms-vscode.cpptools;
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
  css = {
    enable = mkEnableOption "Enable CSS";
    extensions = mkOption {
      type = with types; listOf package;
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
  html = {
    enable = mkEnableOption "Enable html";
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
  java = {
    enable = mkEnableOption "Enable Java";
    extensions = mkOption {
      type = with types; listOf package;
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
      default = { };
    };
  };
  just = {
    enable = mkEnableOption "Enable Typst";
    extensions = mkOption {
      type = with types; listOf package;
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
      type = with types; listOf package;
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
      type = with types; listOf package;
      default = with pkgs.vscode-extensions; [
        davidanson.vscode-markdownlint
      ];
    };
    keybindings = mkOption {
      type = keybindingSubmodule;
      default =
        with lib;
        with pkgs;
        (
          optionals stdenv.isDarwin [
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
          ++ optionals stdenv.isLinux [
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
          ]
        );
    };
    userSettings = mkOption {
      inherit (jsonFormat) type;
      default = {
        # Multiple choices for configured formatters
        "[markdown]" = {
          "editor.defaultFormatter" = "DavidAnson.vscode-markdownlint";
          # "editor.defaultFormatter": "esbenp.prettier-vscode"
        };
      };
    };
  };
  nix = {
    enable = mkEnableOption "Enable Nix";
    extensions = mkOption {
      type = with types; listOf package;
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
  python = {
    enable = mkEnableOption "Enable Python";
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
        "jupyter.askForKernelRestart" = false;
      };
    };
  };
  spell = {
    enable = mkEnableOption "Enable Spellcheck [harper]";
    extensions = mkOption {
      type = with types; listOf package;
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
  typescript = {
    enable = mkEnableOption "Enable Typescript";
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
      default = {
        "typescript.preferences.importModuleSpecifier" = "non-relative";
      };
    };
  };
  typst = {
    enable = mkEnableOption "Enable Typst";
    extensions = mkOption {
      type = with types; listOf package;
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
      };
    };
  };
  yaml = {
    enable = mkEnableOption "Enable YAML";
    extensions = mkOption {
      type = with types; listOf package;
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
