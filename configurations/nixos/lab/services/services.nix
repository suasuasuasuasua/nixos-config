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
    "acme/namecheap_api" = { };
    "duckdns/domains" = { };
    "duckdns/token" = { };
    "firefox-syncserver/token" = { };
    # NOTE: gitlab requires access to the secrets
    "gitlab/databasePassword" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/initialRootPassword" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/secret" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/otpSecret" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/dbSecret" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/oidcKeyBase" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/activeRecordSaltSecret" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/activeRecordPrimaryKeySecret" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
    "gitlab/activeRecordDeterministicKeySecret" = {
      inherit (config.services.gitlab) group;
      owner = config.services.gitlab.user;
    };
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
    gitlab = {
      enable = true;
      databasePasswordFile = config.sops.secrets."gitlab/databasePassword".path;
      initialRootPasswordFile = config.sops.secrets."gitlab/initialRootPassword".path;
      secrets = {
        secretFile = config.sops.secrets."gitlab/secret".path;
        otpFile = config.sops.secrets."gitlab/otpSecret".path;
        dbFile = config.sops.secrets."gitlab/dbSecret".path;
        jwsFile = config.sops.secrets."gitlab/oidcKeyBase".path;
        activeRecordSaltFile = config.sops.secrets."gitlab/activeRecordSaltSecret".path;
        activeRecordPrimaryKeyFile = config.sops.secrets."gitlab/activeRecordPrimaryKeySecret".path;
        activeRecordDeterministicKeyFile =
          config.sops.secrets."gitlab/activeRecordDeterministicKeySecret".path;
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
    uptime-kuma.enable = true;
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
