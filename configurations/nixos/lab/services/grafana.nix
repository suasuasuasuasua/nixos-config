# Grafana visualization and dashboards
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "grafana";

  # default = 3000
  port = 3003;
in
{
  services.grafana = {
    enable = true;
    
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = port;
        domain = "${serviceName}.${hostName}.${domain}";
        root_url = "https://${serviceName}.${hostName}.${domain}";
      };
    };

    provision = {
      enable = true;
      
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          access = "proxy";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          isDefault = true;
        }
      ];
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        # needed if you need to use WebSocket
        proxyWebsockets = true;
      };
    };
  };
}
