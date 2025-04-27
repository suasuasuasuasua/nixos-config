{
  config,
  lib,
  ...
}:
let
  inherit (config.networking) hostName;
  serviceName = "adguardhome";

  cfg = config.nixos.services.${serviceName};

  settings = import ./settings.nix;
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Network-wide ads & trackers blocking DNS server
    '';
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
    };
    # TODO: could make the block lists an option
  };

  config = lib.mkIf cfg.enable {
    services.adguardhome = {
      inherit (cfg) port;
      inherit settings;

      enable = true;
      # https://search.nixos.org/options?channel=24.11&show=services.adguardhome.openFirewall&from=0&size=50&sort=relevance&type=packages&query=adguard
      # opens the web port, not the dns port!
      openFirewall = true;
    };

    services.nginx.virtualHosts = {
      "${serviceName}.${hostName}.home" = {
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.port}";
        };
      };
    };

    networking.firewall = {
      # https://github.com/AdguardTeam/AdGuardHome/wiki/Docker
      # copying these ports
      allowedTCPPorts = [
        53
        68
        80
        443
        853
      ];
      allowedUDPPorts = [
        53
        67
        68
      ];
    };
  };

}
