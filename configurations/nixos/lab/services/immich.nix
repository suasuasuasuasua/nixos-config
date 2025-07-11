# https://wiki.nixos.org/wiki/Immich
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
  # https://wiki.nixos.org/wiki/Immich
  services.immich = {
    inherit port mediaLocation;

    enable = true;
    accelerationDevices = null;
    machine-learning.enable = true;
    settings = { };
  };

  users.users.immich.extraGroups = [
    "samba"
    "video"
    "render"
  ];

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://[::1]:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
      };

      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };
  };
}
