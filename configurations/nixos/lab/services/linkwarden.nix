# linkwarden is a self-hosted collaborative bookmark manager to collect, organize, and preserve webpages, articles, and more
{
  config,
  inputs,
  infra,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "linkwarden";
  environmentFile = config.sops.secrets."linkwarden/environmentFile".path;
in
{
  sops.secrets."linkwarden/environmentFile".sopsFile = "${inputs.self}/secrets/secrets.yaml";

  services.linkwarden = {
    inherit environmentFile;

    enable = true;
    host = "127.0.0.1";
    port = infra.ports.linkwarden;

    database.createLocally = true;
  };

  services.nginx.virtualHosts."${serviceName}.${domain}" = {
    enableACME = true;
    forceSSL = true;
    acmeRoot = null;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString infra.ports.linkwarden}";
      proxyWebsockets = true; # needed if you need to use WebSocket

      extraConfig =
        # allow for larger file uploads through the reverse proxy
        "client_max_body_size 0;";
    };

    serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
  };
}
