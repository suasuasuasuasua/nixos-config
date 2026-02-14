# https://wiki.nixos.org/wiki/WireGuard
# wireguard is a lightweight vpn protocol and server
#
# NOTE: This configuration requires the wireguard/private_key to be present in
# secrets/secrets.yaml. Migrate the key from configurations/nixos/lab/secrets.yaml
# using: sops -d configurations/nixos/lab/secrets.yaml (to view) and
# sops secrets/secrets.yaml (to edit and add the wireguard section).
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
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };
  # enable NAT
  networking = {
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    nat = {
      enable = true;
      # External interface name for pi host (confirmed from system: see configurations/nixos/pi/README.md)
      # Lab uses `enp4s0`, pi uses `end0`
      externalInterface = "end0";
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
