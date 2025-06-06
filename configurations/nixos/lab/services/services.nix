{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
in
{
  imports = [ "${inputs.self}/modules/nixos/services" ];

  # services
  nixos.services = {
    acme.enable = true;
    actual.enable = true;
    adguardhome.enable = true;
    audiobookshelf.enable = true;
    avahi.enable = true;
    calibre = {
      enable = true;
      libraries = [ "/zshare/media/books/ebooks/" ];
    };
    code-server.enable = true;
    dashy = {
      enable = true;
      settings = import ./dashy.nix {
        inherit hostName domain;
      };
    };
    duckdns = {
      enable = true;
      domains = [ "vpn-sua" ];
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
    wireguard = {
      enable = true;
      interfaces = import ./wireguard.nix {
        inherit pkgs;
      };
    };
  };
}
