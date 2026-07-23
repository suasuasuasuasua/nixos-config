{ config, inputs, ... }:
let
  environmentFile = config.sops.secrets."acme/namecheap_api".path;
in
{
  sops.secrets."acme/namecheap_api".sopsFile = "${inputs.self}/secrets/secrets.yaml";

  security.acme = {
    acceptTerms = true;

    defaults = {
      inherit environmentFile;

      email = "admin+justinhoang@sua.dev";
      dnsResolver = "8.8.8.8:53";
      dnsProvider = "namecheap";
      dnsPropagationCheck = true;
    };

    certs."hp-optiplex0.ts.sua.dev" = {
      reloadServices = [ "xrdp" ];
    };
  };
}
