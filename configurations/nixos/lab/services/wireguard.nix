# Lab WireGuard configuration.
# wg1: client on VPS0's proxy tunnel (10.101.0.0/24) for public service forwarding.
# wg0 has been replaced by Tailscale — see tailscale.nix.
{
  inputs,
  config,
  pkgs,
  infra,
  ...
}:
{
  sops.secrets."wireguard/private_key".sopsFile =
    "${inputs.self}/configurations/nixos/lab/secrets.yaml";

  networking.firewall = {
    # Allow VPS to reach lab's nginx and container registry over wg1.
    # These ports are only open on wg1 — closed on the public interface.
    interfaces.wg1.allowedTCPPorts = [
      infra.ports.https # nginx → Gitea
      infra.ports.dockerRegistry # container registry for custom images on runners
    ];
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      # wg1: lab is a client on VPS0's wg1 proxy tunnel (10.101.0.0/24).
      # Intentionally separate from tailscale0 so the proxy tunnel has its own
      # unambiguous source IP for VPS0's nginx stream proxies.
      wg1 = {
        ips = [ "${infra.lab.wg1IP}/24" ];

        privateKeyFile = config.sops.secrets."wireguard/private_key".path;

        peers = [
          {
            name = "hetzner-cloud-vps0";
            publicKey = infra.vps0.wg1PublicKey;
            endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg1Port}";
            allowedIPs = [
              "${infra.hp-optiplex0.wg1IP}/32"
              "${infra.vps0.wg1IP}/32"
            ];
            # Lab is behind NAT — keepalives maintain the mapping so VPS0 can
            # initiate traffic back to lab.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  environment.systemPackages = [
    pkgs.wireguard-tools
  ];
}
