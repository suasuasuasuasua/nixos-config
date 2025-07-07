{
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "adguardhome";

  settings = import ./settings.nix {
    inherit (config.networking) domain;
  };

  # default = 3000
  port = 3000;
in
{
  services.adguardhome = {
    inherit port settings;

    openFirewall = true;

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
      80
      443
      853
    ];
    allowedUDPPorts = [
      53
      67
      68
    ];
  };
}
