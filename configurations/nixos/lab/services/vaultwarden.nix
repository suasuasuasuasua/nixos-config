{
  inputs,
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "vaultwarden";

  port = 8222;
  environmentFile = config.sops.secrets."vaultwarden/environmentFile".path;
in
{
  sops.secrets = {
    "vaultwarden/environmentFile" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.vaultwarden = {
    inherit environmentFile;

    enable = true;
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = port;
      DOMAIN = "https://${serviceName}.${domain}";

      ROCKET_LOG = "critical";
      SIGNUPS_ALLOWED = true;
    };
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
