# Updated lab WireGuard config - lab becomes client of VPS
# Replace the current interfaces.nix with this when ready to migrate
{ config, ... }:
{
  # wg0 = lab as CLIENT connecting to VPS
  wg0 = {
    # Lab's VPN IP in the 10.1.0.0/24 network
    ips = [ "10.1.0.2/24" ];

    # Lab no longer listens for incoming connections (VPS does)
    # Instead, lab initiates connection to VPS
    # listenPort removed - clients don't need to listen

    # Private key file for lab
    privateKeyFile = config.sops.secrets."wireguard/private_key".path;

    peers = [
      {
        name = "vps-server";
        # VPS's public key (you'll generate this)
        publicKey = "REPLACE_WITH_VPS_PUBLIC_KEY";
        # VPS's public IP address
        endpoint = "VPS_PUBLIC_IP:51820";
        # Lab is allowed to use this IP on the VPN
        allowedIPs = [ "10.1.0.0/24" ];
        # Keep-alive for NAT traversal (important for home connections)
        persistentKeepalive = 25;
      }
    ];
  };
}
