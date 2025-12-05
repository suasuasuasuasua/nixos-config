{
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "adguardhome";

  # Pi host's static IP address
  # Defined in one place to avoid duplication across configuration files
  piIP = "192.168.0.250";

  settings = import ./settings.nix {
    inherit (config.networking) domain;
    inherit piIP;
  };

  # default = 3000
  port = 3000;
in
{
  services.adguardhome = {
    inherit port settings;

    enable = true;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
      };

      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };
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
