# Prometheus monitoring server
{ config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "prometheus";

  # default = 9090
  port = 9090;
in
{
  services.prometheus = {
    inherit port;

    enable = true;

    # Retain metrics for 15 days
    retentionTime = "15d";

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9100;
        extraFlags = [
          "--collector.ethtool"
          "--collector.softirqs"
          "--collector.tcpstat"
          "--collector.wifi"
        ];
      };
    };

    scrapeConfigs = [
      {
        job_name = "lab";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }
      {
        job_name = "pi";
        static_configs = [
          {
            targets = [ "pi.${domain}:9100" ];
          }
        ];
      }
    ];
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
