{
  inputs,
  pkgs,
  ...
}:
{
  home-manager.users."justinhoang" = {
    imports = [
      "${inputs.self}/modules/home/cli"
      "${inputs.self}/modules/home/gui"

      ./nixvim.nix
      ./packages.nix
    ];

    custom.home = {
      cli = {
        bat.enable = true; # better cat
        btop.enable = true; # system monitor
        comma.enable = true; # try out programs with `,`
        devenv.enable = true; # easy dev environemnts
        direnv.enable = true; # switch dev environments with .envrc files
        fzf.enable = true; # fuzzy finder
        git.enable = true; # source control
        github.enable = true; # github cli integration
        gnupg.enable = true; # gpg key signing
        starship.enable = true;
        tmux.enable = true; # terminal multiplexer
        zsh.enable = true; # preferred shell
      };
      gui = {
        firefox.enable = true; # browser
        spotify.enable = true; # music platform
        vscode = {
          enable = true;
          profiles = {
            "Data Science".enable = true;
            "Flutter Development".enable = true;
            "Maximal".enable = true;
            "Web Development".enable = true;
          };
          extensions = with pkgs.vscode-extensions; [
            github.copilot
            github.copilot-chat
          ];
          userSettings = {
            "chat.agent.enabled" = true;
            # WARNING: overriden by stylix
            # "editor.fontSize" = 13;
          };
        };
        zed.enable = true;
      };
    };

    # NOTE: darwin module provides the home manager module
    # add under each user rather than global under stylix.nix
    stylix.targets = {
      firefox = {
        enable = true;
        colorTheme.enable = true;
        profileNames = [
          "personal"
          "productivity"
        ];
      };

      vscode = {
        enable = true;
        profileNames = [
          "default"
          "Data Science"
          "Flutter Development"
          "Maximal"
          "Web Development"
        ];
      };
    };
  };
}
