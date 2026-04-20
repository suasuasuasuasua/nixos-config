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
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = [ "10.101.0.1/24" ];
      listenPort = 51820;

      # Run on VPS after boot:
      # $ wg genkey > /etc/wireguard/wg0.key
      # $ chmod 600 /etc/wireguard/wg0.key
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
