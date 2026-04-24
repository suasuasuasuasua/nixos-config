{
  config,
  pkgs,
  infra,
  ...
}:
{
  # wg0: lab acts as a VPN server for personal devices (phones, laptops, etc.)
  # on the 10.100.0.0/24 subnet.
  wg0 = {
    ips = [ "${infra.lab.wg0Ip}/24" ];
    listenPort = infra.lab.wgPort;

    postSetup =
      # bash
      ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${infra.lab.wg0Subnet} -o enp4s0 -j MASQUERADE
      '';

    postShutdown =
      # bash
      ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${infra.lab.wg0Subnet} -o enp4s0 -j MASQUERADE
      '';

    privateKeyFile = config.sops.secrets."wireguard/private_key".path;

    peers = [
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
    ];
  };

  # wg1: lab acts as a client to the VPS on the 10.101.0.0/24 subnet.
  #
  # This is intentionally a separate interface from wg0. When both roles shared
  # wg0, the kernel picked 10.100.0.1 (the primary address) as the source for
  # traffic to the VPS, but VPS only allows 10.101.0.2. Splitting into wg1
  # gives the tunnel its own interface with a single unambiguous IP.
  wg1 = {
    ips = [ "${infra.lab.wg1Ip}/24" ];

    privateKeyFile = config.sops.secrets."wireguard/private_key".path;

    peers = [
      {
        name = "hetzner-cloud-vps0";
        publicKey = "k2a0D0OUEsZQV6geIKOscTNVbiUVZquqh49zT6A1MRo=";
        endpoint = "${infra.vps0.publicIp}:${toString infra.vps0.wgPort}";
        allowedIPs = [
          "${infra.vps0.wg1Ip}/32" # VPS0
          "${infra.vps1.wg1Ip}/32" # VPS1 (routed through VPS0 as hub)
        ];
        # Lab is behind NAT, so it must send keepalives to maintain the
        # mapping and allow VPS to initiate traffic back.
        persistentKeepalive = 25;
      }
    ];
  };
}
