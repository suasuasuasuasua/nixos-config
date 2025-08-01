{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) (
      [
        # apps
        "appcleaner"
        "betterdisplay"
        "betterttv"
        "discord"
        "obsidian"
        "shottr"
        "spotify"
      ]
      ++ [
        # vscode
        "code"
        "vscode"
        "vscode-extension-github-codespaces"
        "vscode-extension-github-copilot"
        "vscode-extension-github-copilot-chat"
        "vscode-extension-ms-dotnettools-csharp"
        "vscode-extension-ms-vscode-cpptools"
        "vscode-extension-ms-vscode-remote-remote-containers"
        "vscode-extension-ms-vscode-remote-remote-ssh"
        "vscode-extension-ms-vscode-remote-remote-ssh-edit"
      ]
    );
}
