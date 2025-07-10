# duckdns is a free dynamic dns website and service
#
# since ISPs usually change residential IP addresses every once in a while, we
# run a script once in a while to ensure that the IP address is always updated
{
  inputs,
  config,
  ...
}:
let
  domainsFile = config.sops.secrets."duckdns/domains".path;
  tokenFile = config.sops.secrets."duckdns/token".path;
in
{
  sops.secrets = {
    "duckdns/domains" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
    "duckdns/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };
  services.duckdns = {
    inherit domainsFile tokenFile;

    enable = true;
  };
}
