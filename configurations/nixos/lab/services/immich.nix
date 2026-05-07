# https://wiki.nixos.org/wiki/Immich
# immich is a self hosted photo and video organizer
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "immich";

  mediaLocation = "/zshare/personal/images";
in
{
  # https://wiki.nixos.org/wiki/Immich
  services.immich = {
    inherit mediaLocation;

    enable = true;
    port = infra.ports.immich;
    accelerationDevices = null;
    machine-learning.enable = true;
    settings = { };
  };

  users.users.immich.extraGroups = [
    "samba"
    "video"
    "render"
  ];

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://[::1]:${toString infra.ports.immich}";
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

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
