# https://wiki.nixos.org/wiki/Home_Assistant
# self hosted automation and home management solution
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "home-assistant";
in
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
      # NOTE: fixes to get started
      "apple_tv"
      "cast"
      "androidtv_remote"
      "ibeacon"
      "otbr"
      "wiz"
    ];
    config = {
      http = {
        server_port = infra.ports.home-assistant;
        server_host = "::1";
        trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };

      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
  };
  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      extraConfig = ''
        proxy_buffering off;
      '';
      locations."/" = {
        proxyPass = "http://[::1]:${toString infra.ports.home-assistant}";
        proxyWebsockets = true;
      };
      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };
  };
}
