# Lab WireGuard configuration.
#
# Lab runs two WireGuard interfaces, both as clients to VPS0:
#   wg0 — client on VPS0's VPN (10.100.0.0/24), for reaching personal devices and pi
#   wg1 — client on VPS0's proxy tunnel (10.101.0.0/24)
#
# See interfaces.nix for peer definitions and the reasoning behind the split.
{
  inputs,
  config,
  pkgs,
  infra,
  ...
}:
{
  sops.secrets = {
    "wireguard/private_key" = {
      sopsFile = "${inputs.self}/configurations/nixos/lab/secrets.yaml";
    };
  };

  networking = {
    firewall = {
      # Allow the VPS to reach lab's nginx and container registry over WireGuard.
      # These ports are only open on wg1 — they remain closed on the public interface.
      interfaces.wg1.allowedTCPPorts = [
        infra.ports.https # nginx → Gitea
        infra.ports.dockerRegistry # container registry for VPS1 runner image
      ];
    };

    # allows for routing from wg0 to LAN, acting like the middleman essentially
    nat = {
      enable = true;
      externalInterface = "enp4s0";
      internalInterfaces = [ "wg0" ];
    };
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      # wg0: lab is a client on VPS0's wg0 VPN (10.100.0.0/24).
      # VPS0 is the server; personal devices, lab, and pi are all peers.
      # Lab's home IP is never exposed — all connections go to VPS0's public IP.
      wg0 = {
        ips = [ "${infra.lab.wg0IP}/24" ];

        privateKeyFile = config.sops.secrets."wireguard/private_key".path;

        peers = [
          {
            name = "hetzner-cloud-vps0";
            publicKey = infra.vps0.wg0PublicKey;
            endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg0Port}";
            allowedIPs = [ infra.vps0.wg0Subnet ];
            # Lab is behind NAT — keepalives maintain the mapping so VPS0 can
            # route packets back to lab.
            persistentKeepalive = 25;
          }
        ];
      };

      # wg1: lab is a client on VPS0's wg1 proxy tunnel (10.101.0.0/24).
      #
      # This is intentionally a separate interface from wg0. When both roles shared
      # wg0, the kernel picked 10.100.0.1 (the primary address) as the source for
      # traffic to the VPS, but VPS only allows 10.101.0.2. Splitting into wg1
      # gives the tunnel its own interface with a single unambiguous IP.
      wg1 = {
        ips = [ "${infra.lab.wg1IP}/24" ];

        privateKeyFile = config.sops.secrets."wireguard/private_key".path;

        peers = [
          {
            name = "hetzner-cloud-vps0";
            publicKey = infra.vps0.wg1PublicKey;
            endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg1Port}";
            allowedIPs = [
              "${infra.vps0.wg1IP}/32" # VPS0
              "${infra.vps1.wg1IP}/32" # VPS1 (routed through VPS0 as hub)
            ];
            # Lab is behind NAT, so it must send keepalives to maintain the
            # mapping and allow VPS to initiate traffic back.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
