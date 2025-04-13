{ inputs, ... }:
{
  imports = [ "${inputs.self}/modules/nixos/services" ];

  # services
  config.nixos.services = {
    actual.enable = true;
    adguardhome.enable = true;
    audiobookshelf.enable = true;
    calibre = {
      enable = true;
      libraries = [ "/zshare/media/books/ebooks/" ];
    };
    # code-server.enable = true; # TODO: bug with 100% CPU usage? (1 core)
    dashy.enable = true;
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
    samba.enable = true;
    syncthing.enable = true;
    vscode-server.enable = true;
    wastebin.enable = true;
  };
}
