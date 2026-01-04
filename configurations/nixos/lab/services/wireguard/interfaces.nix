{ config, pkgs, ... }:
{
  # "wg0" is the network interface name. You can name the interface arbitrarily.
  wg0 = {
    # Determines the IP address and subnet of the server's end of the tunnel interface.
    ips = [ "10.100.0.1/24" ];

    # The port that WireGuard listens to. Must be accessible by the client.
    listenPort = 51820;

    # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
    # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
    # ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT;
    postSetup =
      # bash
      ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp4s0 -j MASQUERADE
      '';

    # This undoes the above command
    # ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT;
    postShutdown =
      # bash
      ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp4s0 -j MASQUERADE
      '';

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
        name = "mbp3.local";
        # Public key of the peer (not a file path).
        publicKey = "5U5c73rfEZ6uSJuVZQudKX5Ir5dZHSq1rmsiKsgzJmI=";
        # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
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
    ];
  };
}
