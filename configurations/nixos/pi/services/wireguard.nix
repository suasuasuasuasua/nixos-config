# Pi is a client on VPS0's wg0 VPN (10.100.0.0/24).
# All personal devices and lab are peers on the same VPN — no home IP exposed.
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

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "${infra.pi.wg0IP}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = infra.vps0.wg0PublicKey;
          endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg0Port}";
          allowedIPs = [ infra.vps0.wg0Subnet ];
          # Pi is behind NAT — keepalives maintain the mapping so VPS0 can
          # route packets back to pi.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  environment.systemPackages = [
    pkgs.wireguard-tools
  ];
}
