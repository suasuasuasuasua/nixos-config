{
  services.gnome.gnome-remote-desktop.enable = true;

  # Only allow RDP on the Tailscale interface (not exposed publicly)
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];
}
