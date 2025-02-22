{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  # TODO: figure out a dynamic way to allocate this (not that there any other
  # users...just helps my brain avoid hardcode)

  # Enable home-manager for "justinhoang" user
  home-manager.users."justinhoang" = {
    imports = [ (self + /configurations/home/justinhoang.nix) ];

    # TODO: if this gets too complex/long, modularize into folders
    config.home.cli = {
      bat.enable = true;
      devenv.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      git.enable = true;
      github.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
    };

    config.home.development = {
      neovim.enable = true;
      packages.enable = true;
      shell.enable = true;
    };
  };
}
