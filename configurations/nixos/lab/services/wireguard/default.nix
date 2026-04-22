# Lab WireGuard configuration.
#
# Lab runs two WireGuard interfaces:
#   wg0 — VPN server for personal devices (10.100.0.0/24)
#   wg1 — client tunnel to VPS (10.101.0.0/24)
#
# See interfaces.nix for peer definitions and the reasoning behind the split.
{
  config,
  inputs,
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

  networking = {
    firewall = {
      allowedUDPPorts = [ 51820 ];
      # Allow the VPS to reach lab's nginx over the WireGuard tunnel.
      # Port 443 is only open on wg1 — it remains closed on the public interface.
      interfaces.wg1.allowedTCPPorts = [
        443
        2222
      ];
    };
    # NAT for wg0 so devices on 10.100.0.0/24 can reach the internet through lab.
    # wg1 is a client-only tunnel and does not need NAT.
    nat = {
      enable = true;
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
