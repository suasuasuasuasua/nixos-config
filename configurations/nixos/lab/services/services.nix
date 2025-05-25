{ inputs, config, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [ "${inputs.self}/modules/nixos/services" ];

  # services
  nixos.services = {
    actual.enable = true;
    adguardhome.enable = true;
    audiobookshelf.enable = true;
    avahi.enable = true;
    calibre = {
      enable = true;
      libraries = [ "/zshare/media/books/ebooks/" ];
    };
    # code-server.enable = true; # WARNING: bug with 100% CPU usage? (1 core)
    dashy = {
      enable = true;
      settings = import ./dashy.nix {
        inherit hostName config;
      };
    };
    gitweb = {
      enable = true;
      projectroot = "/zshare/srv/git";
    };
    glances.enable = true;
    immich = {
      enable = true;
      mediaLocation = "/zshare/personal/images";
    };
    jellyfin.enable = true;
    jellyseerr.enable = true;
    mealie.enable = true;
    navidrome = {
      enable = true;
      MusicFolder = "/zshare/media/music";
    };
    nginx.enable = true;
    ollama = {
      enable = true;
      acceleration = false; # no gpu sadge
    };
    open-webui.enable = true;
    paperless = {
      enable = true;
      mediaDir = "/zshare/personal/docs";
    };
    samba = {
      enable = true;
      settings = import ./samba.nix;
    };
    stirling-pdf.enable = true;
    syncthing = {
      enable = true;
      settings = import ./syncthing.nix;
    };
    vscode-server.enable = true;
    wastebin.enable = true;
  };
}
