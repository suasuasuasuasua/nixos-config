# miniflux is a self hosted rss aggregator
{
  config,
  inputs,
  infra,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "miniflux";

  adminCredentialsFile = config.sops.secrets."miniflux/credentials".path;
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
      LISTEN_ADDR = "127.0.0.1:${toString infra.ports.miniflux}";
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.miniflux}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
