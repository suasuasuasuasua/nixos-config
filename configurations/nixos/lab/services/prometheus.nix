# Prometheus monitoring server
{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "prometheus";
in
{
  services.prometheus = {
    enable = true;

    # Retain metrics for 15 days
    retentionTime = "15d";

    port = infra.ports.prometheus.server;
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = infra.ports.prometheus.exporter;
        extraFlags = [
          "--collector.ethtool"
          "--collector.softirqs"
          "--collector.tcpstat"
          "--collector.wifi"
        ];
      };

      nginx = {
        enable = true;
        port = infra.ports.prometheus.nginx;
      };

      wireguard = {
        enable = true;
        port = infra.ports.prometheus.wireguard;
      };

      zfs = {
        enable = true;
        port = infra.ports.prometheus.zfs;
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
        job_name = "lab-nginx";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}" ];
          }
        ];
      }
      {
        job_name = "lab-wireguard";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.wireguard.port}" ];
          }
        ];
      }
      {
        job_name = "lab-zfs";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.zfs.port}" ];
          }
        ];
      }
      {
        job_name = "pi";
        static_configs = [
          {
            targets = [ "pi.${domain}:${toString infra.ports.prometheus.exporter}" ];
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
        proxyPass = "http://127.0.0.1:${toString infra.ports.prometheus.server}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
