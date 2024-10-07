let
  name = "jellyfin";
  host = "localhost";
  port = "8096";
in {
  services.jellyfin = {
    enable = true;
  };

  services.nginx.virtualHosts."${name}.local" = {
    locations."/" = {
      proxyPass = "http://${host}:${port}/";
    };
  };
}
