# WireGuard VPN server on VPS
# This is the endpoint that lab and other servers connect to
{
  pkgs,
  ...
}:
let
  # Lab server's WireGuard IP and public key
  # You'll need to generate keys and fill these in
  labPublicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";
in
{
  # TODO: After VPS is running, add WireGuard private key to /etc/wireguard/wg0.key
  # For initial setup, we skip sops and manual key setup
  # Run on VPS after boot:
  # $ wg genkey > /etc/wireguard/wg0.key
  # $ chmod 600 /etc/wireguard/wg0.key

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "10.101.0.1/24" ];
      listenPort = 51820;

      # TODO: Generate private key and place in this file
      privateKeyFile = "/etc/wireguard/wg0.key";

      peers = [
        {
          name = "lab";
          publicKey = labPublicKey;
          allowedIPs = [ "10.101.0.2/32" ];
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
