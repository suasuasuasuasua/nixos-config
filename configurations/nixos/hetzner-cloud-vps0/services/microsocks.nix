# SOCKS5 proxy for routing qBittorrent traffic through the VPS.
# Only accessible via Tailscale (port 1080 is blocked on public interfaces).
#
# qBittorrent: Settings > Connection > Proxy Server
#   Type: SOCKS5, Host: hetzner-cloud-vps0.ts.sua.dev, Port: 1080
#   Check "Use proxy for peer connections"
{
  services.microsocks = {
    enable = true;
    port = 1080;
    ip = "0.0.0.0";
  };

  # Only allow port 1080 on the Tailscale interface, not the public internet
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 1080 ];
}
