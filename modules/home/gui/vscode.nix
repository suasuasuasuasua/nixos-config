{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home.gui.vscode;
in
{
  options.home.gui.vscode = {
    enable = lib.mkEnableOption "Enable Visual Studio Code";
    extensions = lib.mkOption {
      type = with lib.types; listOf package;
      default =
        with pkgs.vscode-extensions;
        [
          # General
          aaron-bond.better-comments # colorized comments
          adpyke.codesnap # screenshot code
          christian-kohler.path-intellisense # autofill file and folder paths
          codezombiech.gitignore # gitignore templates
          gruntfuggly.todo-tree # todo tree view
          hediet.vscode-drawio # draw.io integration
          johnpapa.vscode-peacock # colorized projects
          mikestead.dotenv # [dot] env file integration
          mkhl.direnv # direnv integration
          vscodevim.vim # vim emulation
          waderyan.gitblame # git blame

          # Formatters and Linters
          davidanson.vscode-markdownlint # Markdown
          esbenp.prettier-vscode # General
          ms-python.black-formatter # Python
          valentjn.vscode-ltex # Spell-check (NOTE: "plus" and harper not in nixpkgs)

          # LSPs and more
          james-yu.latex-workshop # LaTeX
          jnoortheen.nix-ide # Nix
          mads-hartmann.bash-ide-vscode # Bash
          ms-python.python # Python
          ms-toolsai.jupyter # Jupyter
          myriad-dreamin.tinymist # Typst
          redhat.java # Java
          redhat.vscode-yaml # YAML

          # Remote
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode-remote.remote-wsl
          ms-vscode-remote.remote-containers
        ]
        ++ (
          if pkgs.stdenv.isLinux then
            with pkgs.vscode-extensions;
            [
              ms-vscode.cpptools
            ]
          else
            [
              # WARNING: cpptools not support on darwin. tracking here...
              # https://github.com/NixOS/nixpkgs/issues/377294
              # https://github.com/nix-community/nix-vscode-extensions/issues/113
            ]

        );
    };
    userSettings = lib.mkOption {
      inherit (pkgs.formats.json { }) type;
      default = {
        "vim.insertModeKeyBindings" = [
          {
            "before" = [
              "j"
              "k"
            ];
            "after" = [
              "<Esc>"
            ];
          }
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
      NIXOS_OZONE_WL = "1";
    };

    programs.vscode = {
      inherit (cfg) extensions userSettings;

      enable = true;
      # NOTE: fhs version exists
      # NOTE:
      # workaround in macOS if app does not automatically run
      # 1. settings>privacy&security>security
      # 2. click allow app
      package = pkgs.vscodium;

      # TODO: profiles available in 25.05 unstable...
    };
  };
}
