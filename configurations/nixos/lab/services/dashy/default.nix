# dashy is a configurable dashboard to show off your services and bookmarks
{
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "dashy";
  settings = import ./settings.nix {
    inherit hostName domain;
  };
in
{
  services.dashy = {
    inherit settings;

    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "${hostName}.${domain}";
    };
  };

  services.nginx.virtualHosts = {
    "${hostName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      serverAliases = [
        "${serviceName}.${hostName}.${domain}"
      ];
    };
  };
}
