{
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "stirling-pdf";

  # default = 8081
  port = 8081;
  environment = {
    SERVER_PORT = port;
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
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket

        extraConfig =
          # allow for larger file uploads like videos through the reverse proxy
          "client_max_body_size 0;";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
