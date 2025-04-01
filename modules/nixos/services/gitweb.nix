{
  config,
  lib,
  ...
}:
let
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
      default = "/srv/git";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitweb = {
      inherit (cfg) projectroot;
    };

    services.nginx.gitweb.enable = true;
  };
}
