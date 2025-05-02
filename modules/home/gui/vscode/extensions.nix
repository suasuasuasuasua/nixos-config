{ lib, pkgs, ... }:
lib.mkOption {
  type = with lib.types; listOf package;
  default = with pkgs.vscode-extensions; [
    aaron-bond.better-comments # colorized comments
    adpyke.codesnap # screenshot code
    christian-kohler.path-intellisense # autofill file and folder paths
    codezombiech.gitignore # gitignore templates
    esbenp.prettier-vscode # general linter/formatter
    github.codespaces # codespaces
    github.vscode-github-actions # github actions
    github.vscode-pull-request-github # pull requests
    gruntfuggly.todo-tree # todo tree view
    hediet.vscode-drawio # draw.io integration
    johnpapa.vscode-peacock # colorized projects
    mikestead.dotenv # [dot] env file integration
    mkhl.direnv # direnv integration
    ms-azuretools.vscode-docker # docker support
    ms-vscode-remote.remote-ssh-edit # edit ssh config files
    ms-vscode-remote.remote-ssh # ssh
    ms-vscode-remote.remote-containers # devcontainers
    tomoki1207.pdf # integrated pdf viewer
    vscodevim.vim # vim emulation
  ];
}
