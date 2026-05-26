{ pkgs, ... }:
{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.i3-rounded}/bin/i3";
  };

  # Only allow RDP and VNC on the Tailscale interface (not exposed publicly)
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 5900 ];
}
