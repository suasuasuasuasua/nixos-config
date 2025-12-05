# Prometheus node exporter for system metrics
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
    openFirewall = true;
    extraFlags = [
      "--collector.ethtool"
      "--collector.softirqs"
      "--collector.tcpstat"
      "--collector.wifi"
    ];
  };
}
