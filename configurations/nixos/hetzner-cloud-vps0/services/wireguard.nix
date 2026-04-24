# WireGuard VPN server on VPS
# This is the endpoint that lab connects to
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  vps0Ip = "10.101.0.1";
  labIp = "10.101.0.2";
  vps1Ip = "10.101.0.3";

  labPublicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";
  hetzner-cloud-vps1-key = "X/sp+cUKT7sx9sNnFUXDLylXuIEBx8iTLyG4QBllfS0=";
in
{
  sops.secrets."wireguard/private_key" = {
    sopsFile = "${inputs.self}/configurations/nixos/hetzner-cloud-vps0/secrets.yaml";
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "${vps0Ip}/24" ];
      listenPort = 51820;

      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      peers = [
        {
          name = "lab";
          publicKey = labPublicKey;
          allowedIPs = [ "${labIp}/32" ];
        }
        {
          name = "hetzner-cloud-vps1";
          publicKey = hetzner-cloud-vps1-key;
          allowedIPs = [ "${vps1Ip}/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
