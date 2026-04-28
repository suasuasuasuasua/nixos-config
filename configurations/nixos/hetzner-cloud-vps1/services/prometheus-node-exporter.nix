# Prometheus node exporter for system metrics
{ infra, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = infra.ports.prometheus.exporter;
    openFirewall = true;
    extraFlags = [
      "--collector.ethtool"
      "--collector.softirqs"
      "--collector.tcpstat"
    ];
  };
}
