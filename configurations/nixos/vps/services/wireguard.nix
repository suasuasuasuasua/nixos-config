# WireGuard VPN server on VPS
# This is the endpoint that lab and other servers connect to
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # Lab server's WireGuard IP and public key
  # You'll need to generate keys and fill these in
  labPublicKey = "REPLACE_WITH_LAB_PUBLIC_KEY";
in
{
  sops.secrets = {
    "wireguard/vps_private_key" = {
      sopsFile = "${inputs.self}/configurations/nixos/vps/secrets.yaml";
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "10.1.0.1/24" ];
      listenPort = 51820;

      privateKeyFile = config.sops.secrets."wireguard/vps_private_key".path;

      peers = [
        {
          name = "lab";
          publicKey = labPublicKey;
          allowedIPs = [ "10.1.0.2/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
