{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # configure nixvim here!
  nixvim = inputs.nixvim-config.packages.${system}.default.extend {
    config.nixvim = {
      enable = true;
      lsp = { };
      colorscheme.enable = false;
      plugins = {
        obsidian.enable = false;
      };
    };
  };
in
{
  imports = [
    # import the modules
    "${inputs.self}/modules/home"

    "${inputs.self}/modules/home/cli"
  ];

  home = {
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

    packages = [ nixvim ];
  };
}
