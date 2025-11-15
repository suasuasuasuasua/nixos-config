{
  pkgs,
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "karakeep";

  # default = 9222
  port = 9222;
  PORT = "3004";
in
{
  services = {
    karakeep = {
      # Enable the web interface
      browser = {
        enable = true;
        inherit port;
      };

      extraEnvironment = {
        inherit PORT;
        DISABLE_SIGNUPS = "true";
        DISABLE_NEW_RELEASE_CHECK = "true";
      };

      enable = true;
    };
    meilisearch.package = pkgs.meilisearch;
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true; # needed if you need to use WebSocket
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
