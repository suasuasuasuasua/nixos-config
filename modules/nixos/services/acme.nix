{
  config,
  lib,
  ...
}:
let
  serviceName = "acme";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Secure ACME/Let's Encrypt client
    '';
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      defaults.email = "j124.dev@proton.me";

      # Configure ACME appropriately
      defaults = {
        dnsProvider = "namecheap";
        environmentFile = "/var/lib/secrets/certs.secret";
        dnsPropagationCheck = true;
      };
    };
  };
}
