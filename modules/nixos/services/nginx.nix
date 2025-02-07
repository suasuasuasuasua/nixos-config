{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
in
{
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
  };

  # System
  services.nginx.virtualHosts = {
    "glances.${hostName}.home" = {
      locations."/" = {
        # System overview
        proxyPass = "http://localhost:61208";
      };
    };
  };

  # Networking
  services.nginx.virtualHosts = {
    "adguard.${hostName}.home" = {
      locations."/" = {
        # Adguard Home Adblocker and DNS server
        proxyPass = "http://localhost:3000";
      };
    };
  };

  # Media
  services.nginx.virtualHosts = {
    "jellyfin.${hostName}.home" = {
      locations."/" = {
        # Jellyfin Media
        proxyPass = "http://localhost:8096";
      };
    };
  };

  # Productivity
  services.nginx.virtualHosts = {
    "actual.${hostName}.home" = {
      locations."/" = {
        # Actual finance planner
        proxyPass = "http://localhost:3001";
      };
    };
    "mealie.${hostName}.home" = {
      locations."/" = {
        # Mealie recipe manager
        proxyPass = "http://localhost:9000";
      };
    };
  };
}
