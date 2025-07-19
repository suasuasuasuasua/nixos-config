# bookstack is a self-hosted information management system
{ inputs, config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "bookstack";

  appKeyFile = config.sops.secrets."bookstack/appKey".path;
in
{
  services.bookstack = {
    inherit appKeyFile;

    enable = true;

    hostname = "${serviceName}.${domain}";
    appURL = "https://${serviceName}.${domain}";

    database = {
      createLocally = true;
    };

    nginx = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };

  sops.secrets = {
    "bookstack/appKey" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
      mode = "0440";
      # Either a user id or group name representation of the secret owner
      # It is recommended to get the user name from `config.users.users.<?name>.name` to avoid misconfiguration
      inherit (config.users.users.bookstack) name;
      inherit (config.users.users.bookstack) group;
    };
  };
}
