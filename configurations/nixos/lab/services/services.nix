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

  # This is the actual specification of the secrets.
  sops.secrets = {
    "acme/namecheap_api" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "duckdns/domains" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "duckdns/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "firefox-syncserver/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "gitea/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "miniflux/credentials" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "navidrome/environment" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "vaultwarden/environmentFile" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "wireguard/private_key" = { };
  };

  # services
  nixos.services = {
    acme = {
      enable = true;
      environmentFile = config.sops.secrets."acme/namecheap_api".path;
    };
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
      domainsFile = config.sops.secrets."duckdns/domains".path;
      tokenFile = config.sops.secrets."duckdns/token".path;
    };
    fail2ban.enable = true;
    firefox-syncserver = {
      enable = true;
      secrets = config.sops.secrets."firefox-syncserver/token".path;
    };
    gitea = {
      enable = true;
      stateDir = "/zshare/srv/gitea";
      tokenFile = config.sops.secrets."gitea/token".path;
    };
    gitweb = {
      enable = true;
      projectroot = "/zshare/srv/git";
    };
    glances.enable = true;
    hydra.enable = true;
    immich = {
      enable = true;
      mediaLocation = "/zshare/personal/images";
    };
    jellyfin.enable = true;
    jellyseerr.enable = true;
    mealie.enable = true;
    miniflux = {
      enable = true;
      adminCredentialsFile = config.sops.secrets."miniflux/credentials".path;
    };
    navidrome = {
      enable = true;
      MusicFolder = "/zshare/media/music";
      environmentFile = config.sops.secrets."navidrome/environment".path;
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
    uptime-kuma.enable = true;
    vaultwarden = {
      enable = true;
      environmentFile = config.sops.secrets."vaultwarden/environmentFile".path;
    };
    vscode-server.enable = true;
    wastebin.enable = true;
    wireguard = {
      enable = true;
      interfaces = import ./wireguard.nix {
        inherit config pkgs;
      };
      type = "server";
    };
    ytdl-sub.enable = true;
  };
}
