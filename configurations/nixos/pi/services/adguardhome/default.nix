{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "adguardhome";

  settings = import ./settings.nix {
    inherit (config.networking) domain;
    inherit (infra.pi) tsIP;
    labIP = infra.lab.lanIP;
    piIP = infra.pi.lanIP;
    port = infra.ports.adguardhome;
  };
in
{
  services.adguardhome = {
    inherit settings;

    enable = true;
    port = infra.ports.adguardhome;
  };

  # Must start after tailscaled so it can bind to the Tailscale IP (100.64.0.4).
  systemd.services.adguardhome.after = [ "tailscaled.service" ];

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://localhost:${toString infra.ports.adguardhome}";

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
}
