{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "firefox-syncserver";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Mozilla Sync Storage built with Rust
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 5000;
    };
    secrets = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      mysql.package = pkgs.mariadb;

      firefox-syncserver = {
        inherit (cfg) secrets;

        enable = true;
        singleNode = {
          enable = true;
          enableTLS = true;
          enableNginx = true;
          # See ${hostName}/__heartbeat__ to make sure the server is running
          #
          # Go to about:config and set identity.sync.tokenserver.uri to:
          # - ${hostName}/1.0/sync/1.5
          hostname = "${serviceName}.${hostName}.${domain}";
        };
      };
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.${domain}" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."/" = {
          # enableNginx does 127.0.0.1 for some reason so fine
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
        };
      };
    };
  };
}
