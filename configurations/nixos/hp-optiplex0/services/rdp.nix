{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
  };

  # Only allow RDP on the Tailscale interface (not exposed publicly)
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];
}
