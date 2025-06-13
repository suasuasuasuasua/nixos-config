{ config, ... }:
{
  # "wg0" is the network interface name. You can name the interface arbitrarily.
  wg0 = {
    # Determines the IP address and subnet of the server's end of the tunnel interface.
    ips = [ "10.101.0.1/24" ];

    # The port that WireGuard listens to. Must be accessible by the client.
    listenPort = 51820;

    # https://superuser.com/questions/1716478/wireguard-no-access-to-the-internet

    # Path to the private key file.
    #
    # Note: The private key can also be included inline via the privateKey option,
    # but this makes the private key world-readable; thus, using privateKeyFile is
    # recommended.
    privateKeyFile = config.sops.secrets."wireguard/private_key".path;

    peers = [
      # List of allowed peers.
      {
        # Feel free to give a meaningful name
        name = "lab";
        # Public key of the peer (not a file path).
        publicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";

        # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
        allowedIPs = [
          "::/0"
          "0.0.0.0/0"
          "192.168.0.0/24"
          "10.100.0.0/24"
        ];

        # Set this to the server IP and port.
        endpoint = "192.168.0.240:51820";
        # endpoint = "vpn-sua.duckdns.org:51820";
      }
    ];
  };
}
