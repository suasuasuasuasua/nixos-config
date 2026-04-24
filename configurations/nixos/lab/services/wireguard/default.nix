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
  infra,
  ...
}:
let
  interfaces = import ./interfaces.nix {
    inherit config pkgs infra;
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
      allowedUDPPorts = [ infra.lab.wgPort ];
      # Allow the VPS to reach lab's nginx and container registry over WireGuard.
      # These ports are only open on wg1 — they remain closed on the public interface.
      interfaces.wg1.allowedTCPPorts = [
        infra.ports.https # nginx → Gitea
        infra.ports.dockerRegistry # container registry for VPS1 runner image
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
