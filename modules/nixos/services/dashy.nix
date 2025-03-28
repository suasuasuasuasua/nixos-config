{ config, lib, ... }:
let
  inherit (config.networking) hostName;
  serviceName = "dashy";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      dashy
    '';
  };

  config = lib.mkIf cfg.enable {
    services.dashy = {
      enable = true;
      virtualHost.enableNginx = true;
      virtualHost.domain = "${serviceName}.${hostName}.home";
    };
  };
}
