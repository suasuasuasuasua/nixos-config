{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  services.nginx.virtualHosts = {
    "adguard.lab.home" = {
      locations."/" = {
        # Adguard Home Adblocker and DNS server
        proxyPass = "http://localhost:3000";
      };
    };
    "jellyfin.lab.home" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:8096";
      };
    };
    "dash.lab.home" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:8080";
      };
    };
  };
}
