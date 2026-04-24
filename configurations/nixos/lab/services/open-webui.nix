{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "open-webui";
in
{
  services.open-webui = {
    # Enable the web interface
    enable = true;

    host = "127.0.0.1";
    port = infra.ports.open-webui;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.open-webui}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          "client_max_body_size 0;";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
