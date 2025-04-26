{ lib, pkgs, ... }:
let
  baseExtensions = with pkgs.vscode-extensions; [
    aaron-bond.better-comments # colorized comments
    adpyke.codesnap # screenshot code
    christian-kohler.path-intellisense # autofill file and folder paths
    codezombiech.gitignore # gitignore templates
    ms-azuretools.vscode-docker # docker support
    gruntfuggly.todo-tree # todo tree view
    hediet.vscode-drawio # draw.io integration
    johnpapa.vscode-peacock # colorized projects
    mikestead.dotenv # [dot] env file integration
    mkhl.direnv # direnv integration
    vscodevim.vim # vim emulation
    waderyan.gitblame # git blame
    ms-vscode-remote.vscode-remote-extensionpack # remote
  ];
  formatterExtensions = with pkgs.vscode-extensions; [
    davidanson.vscode-markdownlint # Markdown
    esbenp.prettier-vscode # General
    ms-python.black-formatter # Python
    valentjn.vscode-ltex # Spell-check (NOTE: "ltex plus" and harper not in nixpkgs yet)
  ];
  lspExtensions =
    with pkgs.vscode-extensions;
    [
      james-yu.latex-workshop # LaTeX
      jnoortheen.nix-ide # Nix
      mads-hartmann.bash-ide-vscode # Bash
      ms-python.python # Python
      # Jupyter
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-renderers
      ms-toolsai.jupyter-keymap
      myriad-dreamin.tinymist # Typst
      nefrob.vscode-just-syntax # Just
      redhat.java # Java
      redhat.vscode-yaml # YAML
    ]
    # WARNING: cpptools not supported on darwin. tracking here...
    # https://github.com/NixOS/nixpkgs/issues/377294
    # https://github.com/nix-community/nix-vscode-extensions/issues/113
    ++ lib.optional pkgs.stdenv.isLinux pkgs.vscode-extensions.cpptools;
in
lib.mkOption {
  type = with lib.types; listOf package;
  default = baseExtensions ++ formatterExtensions ++ lspExtensions;
}
