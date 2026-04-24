# Shared network topology for the homelab infrastructure.
# Passed to all NixOS hosts via specialArgs as `infra`.
# Public keys are not secrets — WireGuard public keys are safe to commit.
{
  vps0 = {
    publicIp = "5.78.184.15";
    wg1Ip = "10.101.0.1";
    wg1Subnet = "10.101.0.0/24";
    wgPort = 51820;
    wgPublicKey = "k2a0D0OUEsZQV6geIKOscTNVbiUVZquqh49zT6A1MRo=";
  };
  vps1 = {
    wg1Ip = "10.101.0.3";
    wgPort = 51820;
    wgPublicKey = "X/sp+cUKT7sx9sNnFUXDLylXuIEBx8iTLyG4QBllfS0=";
  };
  lab = {
    lanIp = "192.168.0.240";
    wg0Ip = "10.100.0.1";
    wg0Subnet = "10.100.0.0/24";
    wg1Ip = "10.101.0.2";
    wgPort = 51820;
    wgPublicKey = "JVBP0NWpR70JT0bUoFsunFkGT9YZSY8O/UeMdUxAXlU=";
  };
  pi = {
    lanIp = "192.168.0.250";
  };
  ports = {
    adguardhome = 3000;
    http = 80;
    audiobookshelf = 8000;
    calibre = {
      server = 8080;
      web = 8083;
    };
    firefox-syncserver = 5000;
    glances = 61208;
    grafana = 3005;
    uptime-kuma = 4000;
    home-assistant = 8123;
    hydra = 3002;
    immich = 2283;
    jellyfin = 8086;
    linkwarden = 3004;
    mealie = 9000;
    minecraft-server = 25565;
    miniflux = 9001;
    navidrome = 4533;
    ollama = 11434;
    open-webui = 8082;
    paperless = 28981;
    prometheus = {
      server = 9090;
      exporter = 9100;
      nginx = 9113;
      wireguard = 9586;
      zfs = 9134;
    };
    searxng = 8084;
    stirling-pdf = 8081;
    vaultwarden = 8222;
    wastebin = 8088;
    https = 443;
    actual = 3000;
    gitea = {
      ssh = 2222; # exposed publicly via nginx stream proxy on VPS0
      http = 3001; # lab-internal HTTP port
    };
    "13ft" = 5001;
    dockerRegistry = 5002; # lab-internal Docker registry (WireGuard only)
    it-tools = 8085;
    syncthing = 8384;
    termix = 8086;
  };
}
