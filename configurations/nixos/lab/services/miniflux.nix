# miniflux is a self hosted rss aggregator
{
  inputs,
  config,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "miniflux";

  adminCredentialsFile = config.sops.secrets."miniflux/credentials".path;
  port = 9001;
in
{
  sops.secrets = {
    "miniflux/credentials" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.miniflux = {
    inherit adminCredentialsFile;

    enable = true;
    config = {
      LISTEN_ADDR = "127.0.0.1:${toString port}";
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
