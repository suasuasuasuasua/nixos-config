{ config, lib, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "dashy";

  cfg = config.services.custom.${serviceName};
in
{
  options.services.custom.${serviceName} = {
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
