{
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "adguardhome";
  dnsServiceName = "dns";

  # define static ips
  labIP = "192.168.0.240";
  piIP = "192.168.0.250";

  settings = import ./settings.nix {
    inherit (config.networking) domain;
    inherit labIP piIP;
  };

  # default = 3000
  port = 3000;
in
{
  services.adguardhome = {
    inherit port settings;

    enable = true;
  };

  # Configure ACME certificate for DNS encryption (DoT, DoH, DoQ)
  security.acme.certs."${dnsServiceName}.${domain}" = {
    # Reuse the ACME configuration from the global defaults
    # The certificate will be used for DNS-over-TLS and DNS-over-HTTPS
    group = "adguardhome";
    reloadServices = [ "adguardhome.service" ];
  };

  # Grant AdGuard Home access to the certificate
  users.users.adguardhome.extraGroups = [ "acme" ];

  services.nginx.virtualHosts = {
    # Web interface for AdGuard Home management
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

    # DNS-over-HTTPS endpoint
    "${dnsServiceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      
      locations."/dns-query" = {
        proxyPass = "https://127.0.0.1:443";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
        '';
      };

      serverAliases = [
        "${dnsServiceName}.${hostName}.${domain}"
      ];
    };
  };

  networking.firewall = {
    # https://github.com/AdguardTeam/AdGuardHome/wiki/Docker
    # Port 53: Standard DNS (TCP/UDP)
    # Port 67/68: DHCP
    # Port 443: HTTPS for web interface and DNS-over-HTTPS (DoH)
    # Port 853: DNS-over-TLS (DoT) and DNS-over-QUIC (DoQ)
    allowedTCPPorts = [
      53 # DNS
      68 # DHCP
      443 # HTTPS/DoH
      853 # DoT
    ];
    allowedUDPPorts = [
      53 # DNS
      67 # DHCP
      68 # DHCP
      853 # DoQ (DNS-over-QUIC)
    ];
  };
}
