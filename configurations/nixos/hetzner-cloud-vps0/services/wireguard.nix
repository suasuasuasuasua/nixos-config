# WireGuard on VPS0 — hub for all WireGuard peers.
#
# wg0 (port 51820): VPN server for personal devices, lab, and pi.
#   Personal devices use split-tunnel (AllowedIPs = 10.100.0.0/24) so they
#   keep their normal internet access and only route VPN traffic here.
#
# wg1 (port 51821): Proxy tunnel to lab and VPS1 for public service forwarding.
{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets = {
    "wireguard/wg0_private_key" = {
      sopsFile = "${inputs.self}/configurations/nixos/hetzner-cloud-vps0/secrets.yaml";
    };
    "wireguard/wg1_private_key" = {
      sopsFile = "${inputs.self}/configurations/nixos/hetzner-cloud-vps0/secrets.yaml";
    };
  };

  networking.wireguard = {
    enable = true;

    interfaces.wg0 = {
      ips = [ "${infra.vps0.wg0IP}/24" ];
      listenPort = infra.vps0.wg0Port;

      privateKeyFile = config.sops.secrets."wireguard/wg0_private_key".path;

      peers = [
        # Personal devices — kept at their original IPs from lab's old wg0 server.
        # After generating the wg0 key, update each device's WireGuard config:
        #   Endpoint = ${infra.vps0.publicIP}:${infra.vps0.wg0Port}
        #   PublicKey = <infra.vps0.wg0PublicKey>
        #   AllowedIPs = 10.100.0.0/24  (split tunnel — devices keep normal internet)
        {
          name = "mbp3.local";
          publicKey = "5U5c73rfEZ6uSJuVZQudKX5Ir5dZHSq1rmsiKsgzJmI=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          name = "iphone";
          publicKey = "maAlHZyL5YGILhqm2hCCqTZepTLt7VoEGyWzQca2gVk=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        {
          name = "ipad";
          publicKey = "nh/X2r1YdLV4+rGduCvBTX58DDYYtzrRkZqXfSSGmWY=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
        {
          name = "penguin";
          publicKey = "saosesGsiwLmm+SNP4zRGVuWaswmimm2C0WiW2/TPXI=";
          allowedIPs = [ "10.100.0.5/32" ];
        }
        {
          name = "ilmgf";
          publicKey = "ZdAyGNsAEFkN2lc3KtkCX6/n2m+d1wedtuTEKXFSzVc=";
          allowedIPs = [ "10.100.0.6/32" ];
        }
        # Lab and pi — NixOS machines configured as wg0 clients below.
        {
          name = "lab";
          publicKey = infra.lab.wgPublicKey;
          allowedIPs = [
            "${infra.lab.wg0IP}/32"
            "192.168.0.0/24"
          ];
        }
        {
          name = "pi";
          publicKey = infra.pi.wg0PublicKey;
          allowedIPs = [ "${infra.pi.wg0IP}/32" ];
        }
      ];
    };

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
          name = "hetzner-cloud-vps1";
          publicKey = infra.vps1.wgPublicKey;
          allowedIPs = [ "${infra.vps1.wg1IP}/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
