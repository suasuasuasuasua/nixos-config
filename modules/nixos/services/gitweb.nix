{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitweb";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Distributed version control system
    '';
    projectroot = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      gitweb = {
        inherit (cfg) projectroot;
      };

      nginx = {
        gitweb = {
          enable = true;
          location = "/gitweb";
          virtualHost = "${hostName}.${domain}";
        };

        # add SSL
        virtualHosts = {
          "${hostName}.${domain}" = {
            enableACME = true;
            forceSSL = true;
            acmeRoot = null;
          };
        };
      };
    };
  };
}
