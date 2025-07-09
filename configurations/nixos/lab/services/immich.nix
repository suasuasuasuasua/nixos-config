# immich is a self hosted photo and video organizer
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "immich";

  mediaLocation = "/zshare/personal/images";
  # default = 2283
  port = 2283;
in
{
  users.users.immich.extraGroups = [ "samba" ];

  services.immich = {
    inherit port mediaLocation;

    enable = true;
    machine-learning.enable = true;
    settings = { };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          "client_max_body_size 0;";
      };

      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };
  };
}
