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
        "clion"
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

  nixpkgs.overlays = [
    # TODO: spotify build failure on darwin
    # https://github.com/NixOS/nixpkgs/issues/465676
    (_: prev: {
      spotify = prev.spotify.overrideAttrs (oldAttrs: {
        src =
          if (prev.stdenv.isDarwin && prev.stdenv.isAarch64) then
            prev.fetchurl {
              url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
              hash = "sha256-0gwoptqLBJBM0qJQ+dGAZdCD6WXzDJEs0BfOxz7f2nQ=";
            }
          else
            oldAttrs.src;
      });
    })
  ];
}
