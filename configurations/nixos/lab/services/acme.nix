# https://wiki.nixos.org/wiki/ACME
# acme is used for generating self-signed certificates
#
# this is especially helpful for ensuring TLS compliant websites (https) for
# security reasons
{
  inputs,
  config,
  ...
}:
let
  environmentFile = config.sops.secrets."acme/namecheap_api".path;
in
{
  sops.secrets = {
    "acme/namecheap_api" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      inherit environmentFile;

      email = "admin+justinhoang@sua.sh";
      dnsProvider = "namecheap";
      dnsPropagationCheck = true;
    };
  };
}
