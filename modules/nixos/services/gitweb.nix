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
    enable = lib.mkEnableOption "Enable Gitweb";

    # TODO: add the serve location here
    # TODO: add custom theme?
  };

  config = lib.mkIf cfg.enable {
    services.gitweb = {
      # TODO: make this a dynamic argument?
      # "/srv/git" is the default path
      projectroot = "/zshare/srv/git";
    };

    services.nginx.gitweb.enable = true;
  };
}
