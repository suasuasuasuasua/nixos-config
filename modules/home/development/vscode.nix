{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # General
      vscodevim.vim
      gruntfuggly.todo-tree
      codezombiech.gitignore

      # Remote
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-ssh-edit
      ms-vscode-remote.remote-wsl
      ms-vscode-remote.remote-containers

      # Nix Dev
      jnoortheen.nix-ide
      mkhl.direnv

      # Theme
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
  };
}
