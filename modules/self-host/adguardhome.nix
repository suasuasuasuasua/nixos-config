let
  name = "adguardhome";
  host = "localhost";
  port = "3000";
in {
  services.adguardhome = {
    enable = true;
  };

  services.nginx.virtualHosts."${name}.local" = {
    locations."/" = {
      proxyPass = "http://${host}:${port}/";
    };
  };
}
