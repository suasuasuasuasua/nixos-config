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
    # TODO: add default set of packages or custom config
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
      NIXOS_OZONE_WL = "1";
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium; # NOTE: fhs version exists
      extensions = with pkgs.vscode-extensions; [
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
        ms-vscode.cpptools # C/C++
        myriad-dreamin.tinymist # Typst
        redhat.java # Java
        redhat.vscode-yaml # YAML

        # Remote
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-wsl
        ms-vscode-remote.remote-containers
      ];

      # TODO: profiles available in 25.05 unstable...
    };
  };
}
