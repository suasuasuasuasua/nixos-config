# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{

  imports = [
    self.nixosModules.default

    # import the modules
    (self + /modules/nixos/development)
    (self + /modules/nixos/services)
  ];

  # TODO: if this gets too complex/long, modularize into folders
  config = {
    environment.variables = {
      EDITOR = "nvim";
    };
  };

  # development
  config.nixos.development = {
    cli.enable = true;
    nh.enable = true;
    virtualization.enable = true;
  };

  # services
  config.nixos.services = {
    actual.enable = true;
    adguard.enable = true;
    audiobookshelf.enable = true;
    calibre.enable = true;
    dashy.enable = true;
    gitweb.enable = true;
    glances.enable = true;
    immich.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;
    mealie.enable = true;
    navidrome.enable = true;
    nginx.enable = true;
    samba.enable = true;
    wastebin.enable = true;
  };
}
