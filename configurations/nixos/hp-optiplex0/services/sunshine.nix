{...}: {
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = false;
  };

  # Sunshine ports, Tailscale-only (same pattern as RDP)
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [
      47984 # HTTPS
      47989 # HTTP
      47990 # Web UI
      48010 # RTSP
    ];
    allowedUDPPorts = [
      47998 # Video
      47999 # Control
      48000 # Audio
      48002 # Mic
    ];
  };
}
