{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    "${inputs.self}/modules/home/cli"
    "${inputs.self}/modules/home/gui"
  ];

  # running debian 13!
  targets.genericLinux.enable = true;

  custom.home = {
    cli = {
      atuin.enable = true;
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
      zsh.enable = true;
    };
    # # NOTE: gui apps are weird
    # gui = {
    #   firefox.enable = true;
    #   obs.enable = true;
    #   spotify.enable = true;
    #   zed.enable = true;
    # };
  };

  home = {
    sessionVariables = {
      "EDITOR" = "nvim";
    };
    packages =
      let
        nixvim = inputs.nixvim-config.packages.${system}.default.extend {
          config.plugins.obsidian = {
            package = pkgs.unstable.vimPlugins.obsidian-nvim;
            settings = {
              legacy_commands = false;
            };
          };

          config.nixvim = {
            lsp = { };
            plugins = {
              custom = {
                obsidian = {
                  enable = true;
                  workspaces = [
                    {
                      name = "personal";
                      path = "/home/justinhoang/Documents/vaults/personal";
                    }
                    {
                      name = "productivity";
                      path = "/home/justinhoang/Documents/vaults/productivity";
                    }
                  ];
                };
              };
            };
          };
        };
      in
      [ nixvim ];

  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "betterttv"
      "spotify"
    ];

  stylix.targets = {
    firefox = {
      enable = true;
      colorTheme.enable = true;
      profileNames = [
        "personal"
        "productivity"
      ];
    };
  };
}
