{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  inherit (config.networking) hostName;
  serviceName = "dashy";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Dashy";
  };

  config = lib.mkIf cfg.enable {
    services.dashy = {
      enable = true;
      # option does not exist :(
      # port = 8080;
      virtualHost.enableNginx = true;
      virtualHost.domain = "${serviceName}.${hostName}.home";
    };
  };
}
