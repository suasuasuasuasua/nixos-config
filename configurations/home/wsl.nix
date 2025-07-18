{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  imports = [
    "${inputs.self}/modules/home"
    "${inputs.self}/modules/home/cli"
  ];

  custom.home = {
    cli = {
      bat.enable = true; # better cat
      comma.enable = true; # try out programs with `,`
      devenv.enable = true; # easy dev environemnts
      direnv.enable = true; # switch dev environments with .envrc files
      fzf.enable = true; # fuzzy finder
      git.enable = true; # source control
      github.enable = true; # github cli integration
      gnupg.enable = true; # gpg key signing
      tmux.enable = true; # terminal multiplexer
      zsh.enable = true;
    };
  };

  home.packages =
    # configure nixvim here!
    let
      nixvim = inputs.nixvim-config.packages.${system}.default.extend {
        config.nixvim = {
          colorscheme.enable = false;
          lsp = { };
          plugins = {
            custom = {
              obsidian.enable = false;
            };
          };
        };
      };
    in
    [ nixvim ];
}
