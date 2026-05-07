{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/modules/home"
    "${inputs.self}/modules/home/cli"

    ./nixvim.nix
  ];

  custom.home.cli = {
    bat.enable = true; # better cat
    btop.enable = true; # system monitor
    comma.enable = true; # try out programs with `,`
    direnv.enable = true; # switch dev environments with .envrc files
    fzf.enable = true; # fuzzy finder
    git.enable = true; # source control
    github.enable = true; # github cli integration
    gnupg.enable = true; # gpg key signing
    tmux.enable = true; # terminal multiplexer
    zsh.enable = true;
  };

  home.packages = [ pkgs.devenv ];
}
