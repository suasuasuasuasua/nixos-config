{ lib, pkgs, ... }:
let
  baseExtensions = with pkgs.vscode-extensions; [
    aaron-bond.better-comments # colorized comments
    adpyke.codesnap # screenshot code
    christian-kohler.path-intellisense # autofill file and folder paths
    codezombiech.gitignore # gitignore templates
    esbenp.prettier-vscode # general linter/formatter
    gruntfuggly.todo-tree # todo tree view
    hediet.vscode-drawio # draw.io integration
    johnpapa.vscode-peacock # colorized projects
    mikestead.dotenv # [dot] env file integration
    mkhl.direnv # direnv integration
    ms-azuretools.vscode-docker # docker support
    ms-vscode-remote.vscode-remote-extensionpack # remote
    tomoki1207.pdf # integrated pdf viewer
    vscodevim.vim # vim emulation
  ];
in
lib.mkOption {
  type = with lib.types; listOf package;
  default = baseExtensions;
}
