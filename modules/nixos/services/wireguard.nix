{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  serviceName = "wireguard";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Userspace Go implementation of WireGuard
    '';
    interfaces = lib.mkOption {
      inherit (options.networking.wireguard.interfaces) type;
      default = { };
    };
    type = lib.mkOption {
      type =
        with lib.types;
        enum [
          "client"
          "server"
        ];
    };
  };

  config = lib.mkIf cfg.enable {
    # enable NAT
    networking = {
      firewall = {
        allowedUDPPorts = [ 51820 ];
      };
      nat = lib.mkIf (cfg.type == "server") {
        enable = true;
        # TODO: may need to modularize the external interface name
        # for example, many of the examples had `eth0`
        externalInterface = "enp4s0";
        internalInterfaces = [ "wg0" ];
      };
    };

    networking.wireguard = {
      inherit (cfg) interfaces;

      enable = true;
    };

    environment.systemPackages = with pkgs; [
      wireguard-tools
    ];
  };
}
