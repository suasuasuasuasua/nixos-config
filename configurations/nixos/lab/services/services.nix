{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [ self.nixosModules.default ];

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
    ollama.enable = true;
    paperless.enable = true;
    samba.enable = true;
    wastebin.enable = true;
  };
}
