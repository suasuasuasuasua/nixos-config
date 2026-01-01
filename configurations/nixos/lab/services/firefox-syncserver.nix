# https://wiki.nixos.org/wiki/Firefox_Sync_Server
# firefox syncserver is a self hosted server used to synchronize settings
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "firefox-syncserver";

  port = 5000;
  secrets = config.sops.secrets."firefox-syncserver/token".path;
in
{
  sops.secrets = {
    "firefox-syncserver/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services = {
    mysql.package = pkgs.mariadb;

    firefox-syncserver = {
      inherit secrets;

      enable = true;
      singleNode = {
        enable = true;
        enableTLS = true;
        enableNginx = true;
        # See ${hostName}/__heartbeat__ to make sure the server is running
        #
        # Go to about:config and set identity.sync.tokenserver.uri to:
        # - ${hostName}/1.0/sync/1.5
        hostname = "${serviceName}.${domain}";
      };
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        # enableNginx does 127.0.0.1 for some reason so fine
        proxyPass = "http://127.0.0.1:${toString port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
