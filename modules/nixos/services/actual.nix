{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (flake) inputs;
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "actual";
  port = 3001;

  cfg = config.nixos.services.${serviceName};
in
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/actual.nix"
  ];

  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption "Enable Actual Budget";
  };

  config = lib.mkIf cfg.enable {
    # TODO: need to setup HTTPS to continue using...
    services.actual = {
      enable = true;
      package = pkgs.unstable.actual-server;
      openFirewall = true;
      settings = {
        # default port is 3000
        port = port;
      };
    };
    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          # Actual finance planner
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
  };
}
