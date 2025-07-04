{ inputs, config, ... }:
let
  inherit (config.networking) hostName domain;
in
{
  imports = [
    # import the modules
    "${inputs.self}/modules/nixos/services"
  ];

  # This is the actual specification of the secrets.
  sops.secrets = {
    "acme/namecheap_api" = { };
    "duckdns/domains" = { };
    "duckdns/token" = { };
  };

  # services
  nixos.services = {
    acme = {
      enable = true;
      environmentFile = config.sops.secrets."acme/namecheap_api".path;
    };
    adguardhome.enable = true;
    avahi.enable = true;
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
    glances.enable = true;
    fail2ban.enable = true;
    nginx.enable = true;
    uptime-kuma.enable = true;
  };
}
