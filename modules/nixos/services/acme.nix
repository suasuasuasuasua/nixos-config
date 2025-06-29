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
    environmentFile = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;

      # Configure ACME appropriately
      defaults = {
        inherit (cfg) environmentFile;

        email = "admin+justinhoang@sua.sh";
        dnsProvider = "namecheap";
        dnsPropagationCheck = true;
      };
    };
  };
}
