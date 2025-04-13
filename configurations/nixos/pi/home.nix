{ inputs, ... }:
{
  # TODO: figure out a dynamic way to allocate this (not that there any other
  # users...just helps my brain avoid hardcode)

  # Enable home-manager for "justinhoang" user
  home-manager.users."justinhoang" = {
    imports = [ "${inputs.self}/modules/home" ];

    # TODO: if this gets too complex/long, modularize into folders
  };
}
