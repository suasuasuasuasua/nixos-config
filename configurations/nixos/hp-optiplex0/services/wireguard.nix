{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets."wireguard/private_key".sopsFile =
    "${inputs.self}/configurations/nixos/hp-optiplex0/secrets.yaml";

  networking.wireguard = {
    enable = true;

    # wg0: client on VPS0's VPN (10.100.0.0/24), for reaching personal devices and pi
    interfaces.wg0 = {
      ips = [ "${infra.hp-optiplex0.wg0IP}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = infra.vps0.wg0PublicKey;
          endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg0Port}";
          allowedIPs = [ infra.vps0.wg0Subnet ];
          persistentKeepalive = 25;
        }
      ];
    };

    # wg1: client on VPS0's proxy tunnel (10.101.0.0/24)
    interfaces.wg1 = {
      ips = [ "${infra.hp-optiplex0.wg1IP}/24" ];

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "hetzner-cloud-vps0";
          publicKey = infra.vps0.wg1PublicKey;
          endpoint = "${infra.vps0.publicIP}:${toString infra.vps0.wg1Port}";
          allowedIPs = [
            "${infra.lab.wg1IP}/32"
            "${infra.vps0.wg1IP}/32"
          ];
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Trust the wg0 VPN interface — allows all traffic from 10.100.0.0/24 peers
  networking.firewall.trustedInterfaces = [ "wg0" ];

  environment.systemPackages = [
    pkgs.wireguard-tools
  ];
}
