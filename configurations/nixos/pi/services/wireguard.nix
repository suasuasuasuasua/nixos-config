# Pi WireGuard configuration.
# wg1: client on VPS0's proxy tunnel (10.101.0.0/24) for public service forwarding.
# Follows the same pattern as lab and hp-optiplex0.
{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets."wireguard/private_key".sopsFile =
    "${inputs.self}/configurations/nixos/pi/secrets.yaml";

  networking.firewall = {
    # Allow VPS0 to reach pi's nginx (uptime-kuma) over wg1.
    interfaces.wg1.allowedTCPPorts = [
      infra.ports.https
    ];
  };

  networking.wireguard = {
    enable = true;

    interfaces.wg1 = {
      ips = [ "${infra.pi.wg1IP}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = infra.vps0.wg1PublicKey;
          endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg1Port}";
          allowedIPs = [
            "${infra.vps0.wg1IP}/32"
          ];
          # Pi is behind NAT — keepalives maintain the mapping so VPS0 can
          # initiate traffic back to pi.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  environment.systemPackages = [
    pkgs.wireguard-tools
  ];
}
