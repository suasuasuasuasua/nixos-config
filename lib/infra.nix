# Shared network topology for the homelab infrastructure.
# Passed to all NixOS hosts via specialArgs as `infra`.
# Public keys are not secrets — WireGuard public keys are safe to commit.
{
  lab = {
    lanIP = "192.168.0.240";
    wg0IP = "10.100.0.7"; # lab's IP on VPS0's wg0 (client, not server)
    wg1IP = "10.101.0.2";
    wgPublicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";
  };
  pi = {
    lanIP = "192.168.0.250";
    wg0IP = "10.100.0.8"; # pi's IP on VPS0's wg0 (client)
    wg0PublicKey = "lfHsRVu1iRoxVDBUFNVAPY9JWDdGyIyaLKC83HnknFQ=";
  };
  hp-optiplex0 = {
    lanIP = "192.168.0.251";
    wg1IP = "10.101.0.4";
    wg1Port = 51820;
    wg1PublicKey = "4/h51BZcx+kRFW43X4yoNPmoECX7HYnEn9HFQ+O+zzM=";
  };
  vps0 = {
    publicIP = "5.78.184.15";
    # wg0: VPN server for personal devices, lab, and pi (10.100.0.0/24)
    wg0IP = "10.100.0.1";
    wg0Subnet = "10.100.0.0/24";
    wg0Port = 51820;
    wg0PublicKey = "vbOVT6tJ33lEhDqVBVX6ScF3c7wmijF4vCTqg0ug0z4=";
    # wg1: proxy tunnel to lab and VPS1 (10.101.0.0/24)
    wg1IP = "10.101.0.1";
    wg1Subnet = "10.101.0.0/24";
    wg1Port = 51821;
    wg1PublicKey = "k2a0D0OUEsZQV6geIKOscTNVbiUVZquqh49zT6A1MRo=";
  };
  vps1 = {
    wg1IP = "10.101.0.3";
    wg1Port = 51820;
    wgPublicKey = "X/sp+cUKT7sx9sNnFUXDLylXuIEBx8iTLyG4QBllfS0=";
  };
  ports = {
    http = 80;
    https = 443;
    gitea = {
      ssh = 2222; # exposed publicly via nginx stream proxy on VPS0
      http = 3001; # lab-internal HTTP port
    };
    immich = 2283;
    adguardhome = 3000; # pi
    actual = 3000; # lab
    linkwarden = 3004;
    grafana = 3005;
    uptime-kuma = 4000;
    navidrome = 4533;
    "13ft" = 5001;
    dockerRegistry = 5002; # lab-internal Docker registry (WireGuard only)
    audiobookshelf = 8000;
    calibre = {
      server = 8080;
      web = 8083;
    };
    stirling-pdf = 8081;
    searxng = 8084;
    it-tools = 8085;
    termix = 8086;
    wastebin = 8088;
    jellyfin = 8096;
    home-assistant = 8123;
    vaultwarden = 8222;
    syncthing = 8384;
    mealie = 9000;
    prometheus = {
      server = 9090;
      exporter = 9100;
      nginx = 9113;
      wireguard = 9586;
      zfs = 9134;
    };
    minecraft-server = 25565;
    paperless = 28981;
    glances = 61208;
  };
}
