{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [ (self + /modules/nixos/services) ];

  # services
  config.nixos.services = {
    actual.enable = true;
    adguard.enable = true;
    audiobookshelf.enable = true;
    calibre.enable = true;
    # code-server.enable = true; # TODO: bug with 100% CPU usage? (1 core)
    dashy.enable = true;
    gitweb.enable = true;
    glances.enable = true;
    immich.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;
    mealie.enable = true;
    navidrome.enable = true;
    nginx.enable = true;
    ollama = {
      enable = true;
      open-webui.enable = true;
    };
    paperless.enable = true;
    samba.enable = true;
    vscode-server.enable = true;
    wastebin.enable = true;
  };
}
