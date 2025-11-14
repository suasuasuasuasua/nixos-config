# https://wiki.nixos.org/wiki/WireGuard
# wireguard is a lightweight vpn protocol and server
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  interfaces = import ./interfaces.nix {
    inherit config pkgs;
  };
in
{
  sops.secrets = {
    "wireguard/private_key" = {
      sopsFile = "${inputs.self}/configurations/nixos/lab/secrets.yaml";
    };
  };
  # enable NAT
  networking = {
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    nat = {
      enable = true;
      # TODO: may need to modularize the external interface name
      # for example, many of the examples had `eth0`
      externalInterface = "enp4s0";
      internalInterfaces = [ "wg0" ];
    };
  };

  networking.wireguard = {
    inherit interfaces;

    enable = true;
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
