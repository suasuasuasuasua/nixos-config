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
  };
}
