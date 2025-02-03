{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  # System
  services.nginx.virtualHosts = {
    "glances.lab.home" = {
      locations."/" = {
        # System overview
        proxyPass = "http://localhost:61208";
      };
    };
  };

  # Networking
  services.nginx.virtualHosts = {
    "adguard.lab.home" = {
      locations."/" = {
        # Adguard Home Adblocker and DNS server
        proxyPass = "http://localhost:3000";
      };
    };
  };

  # Media
  services.nginx.virtualHosts = {
    "jellyfin.lab.home" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:8096";
      };
    };
  };

  # Productivity
  services.nginx.virtualHosts = {
    "actual.lab.home" = {
      locations."/" = {
        # Actual finance planner
        proxyPass = "http://localhost:3001";
      };
    };
    "mealie.lab.home" = {
      locations."/" = {
        # Mealie recipe manager
        proxyPass = "http://localhost:9000";
      };
    };
  };
}
