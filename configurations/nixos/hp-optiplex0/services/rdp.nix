{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "startxfce4";
  };

  # Only allow RDP on the WireGuard interface (not exposed publicly)
  networking.firewall.interfaces.wg1.allowedTCPPorts = [ 3389 ];
}
