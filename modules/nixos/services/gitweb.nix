{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
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
    services.gitweb = {
      inherit (cfg) projectroot;
    };

    services.nginx.gitweb = {
      enable = true;
      location = "/gitweb";
      virtualHost = "${hostName}.home";
    };
  };
}
