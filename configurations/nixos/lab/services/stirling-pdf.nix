{
  config,
  infra,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "stirling-pdf";

  environment = {
    SERVER_PORT = infra.ports.stirling-pdf;
    SYSTEM_ENABLEANALYTICS = "false";
  };
in
{
  services.stirling-pdf = {
    inherit environment;

    enable = true;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.stirling-pdf}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          "client_max_body_size 0;";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
