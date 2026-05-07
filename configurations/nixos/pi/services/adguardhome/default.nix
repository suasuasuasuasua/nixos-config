{ config, infra, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "adguardhome";

  settings = import ./settings.nix {
    inherit (config.networking) domain;
    labIP = infra.lab.lanIP;
    piIP = infra.pi.lanIP;
    piWg0IP = infra.pi.wg0IP;
    port = infra.ports.adguardhome;
  };
in
{
  services.adguardhome = {
    inherit settings;

    enable = true;
    port = infra.ports.adguardhome;
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/".proxyPass = "http://localhost:${toString infra.ports.adguardhome}";

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };

  networking.firewall = {
    # https://github.com/AdguardTeam/AdGuardHome/wiki/Docker
    # copying these ports
    allowedTCPPorts = [
      53
      68
      853
    ];
    allowedUDPPorts = [
      53
      67
      68
    ];
  };
}
