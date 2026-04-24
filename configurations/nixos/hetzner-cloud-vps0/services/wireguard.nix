# WireGuard VPN server on VPS
# This is the endpoint that lab connects to
{
  config,
  infra,
  inputs,
  pkgs,
  ...
}:
{
  sops.secrets."wireguard/private_key" = {
    sopsFile = "${inputs.self}/configurations/nixos/hetzner-cloud-vps0/secrets.yaml";
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "${infra.vps0.wgIp}/24" ];
      listenPort = infra.vps0.wgPort;

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "lab";
          publicKey = infra.lab.wgPublicKey;
          allowedIPs = [ "${infra.lab.wgIp}/32" ];
        }
        {
          name = "hetzner-cloud-vps1";
          publicKey = infra.vps1.wgPublicKey;
          allowedIPs = [ "${infra.vps1.wgIp}/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
