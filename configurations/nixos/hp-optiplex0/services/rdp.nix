{ config, ... }:
let
  certDir = config.security.acme.certs."hp-optiplex0.ts.sua.dev".directory;
in
{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "xfce4-session";
    sslCert = "${certDir}/fullchain.pem";
    sslKey = "${certDir}/key.pem";
  };

  users.users.xrdp.extraGroups = [ "acme" ];

  # Only allow RDP on the Tailscale interface (not exposed publicly)
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3389 ];
}
