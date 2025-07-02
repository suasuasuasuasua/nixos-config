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
  Port = 9001;
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
      inherit Port;
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString Port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
