{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  services.nginx.virtualHosts = {
    "adguard.homelab.lan" = {
      locations."/" = {
        # Adguard Home Adblocker and DNS server
        proxyPass = "http://localhost:3000";
      };
    };
    "jellyfin.homelab.lab" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:8096";
      };
    };
  };
}
