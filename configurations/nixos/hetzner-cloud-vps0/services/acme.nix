# ACME/Let's Encrypt setup on VPS
# Note: Lab server manages the actual gitea cert renewal,
# but VPS nginx needs the cert too for SSL termination
{
  config,
  inputs,
  userConfigs,
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
      inherit (userConfigs.admin) email;

      dnsProvider = "namecheap";
      dnsPropagationCheck = true;
    };
  };
}
