# Prometheus node exporter for system metrics
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 9100;
  };

  # Allow Prometheus to scrape metrics from the lab host
  networking.firewall.allowedTCPPorts = [ 9100 ];
}
