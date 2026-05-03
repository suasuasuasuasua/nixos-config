# anki-sync-server is a self-hosted Anki sync server
{
  config,
  infra,
  inputs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "anki";
in
{
  sops.secrets = {
    "anki-sync-server/password" = {
      sopsFile = "${inputs.self}/configurations/nixos/lab/secrets.yaml";
      owner = "anki-sync-server";
    };
  };

  services.anki-sync-server = {
    enable = true;
    address = "127.0.0.1";
    port = infra.ports.anki-sync-server;
    users = [
      {
        username = "justinhoang";
        passwordFile = config.sops.secrets."anki-sync-server/password".path;
      }
    ];
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString infra.ports.anki-sync-server}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
