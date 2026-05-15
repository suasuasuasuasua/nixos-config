# WireGuard on VPS0.
#
# wg1 (port 51821): Proxy tunnel to lab and hp-optiplex0 for public service forwarding.
# wg0 has been replaced by Headscale/Tailscale — see headscale.nix.
{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "wireguard/wg1_private_key".sopsFile =
      "${inputs.self}/configurations/nixos/hetzner-cloud-vps0/secrets.yaml";
  };

  networking.wireguard = {
    enable = true;

    interfaces.wg1 = {
      ips = [ "${infra.vps0.wg1IP}/24" ];
      listenPort = infra.vps0.wg1Port;

      privateKeyFile = config.sops.secrets."wireguard/wg1_private_key".path;

      peers = [
        {
          name = "lab";
          publicKey = infra.lab.wgPublicKey;
          allowedIPs = [ "${infra.lab.wg1IP}/32" ];
        }
        {
          name = "hp-optiplex0";
          publicKey = infra.hp-optiplex0.wgPublicKey;
          allowedIPs = [ "${infra.hp-optiplex0.wg1IP}/32" ];
        }
      ];
    };
  };

  environment.systemPackages = [
    pkgs.wireguard-tools
  ];
}
