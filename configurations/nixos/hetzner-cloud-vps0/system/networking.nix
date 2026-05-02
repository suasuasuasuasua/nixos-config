{ infra, ... }:
{
  # Allow VPS0 to forward packets between WireGuard peers on wg1
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "hetzner-cloud-vps0";
    domain = "sua.dev";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;

      # Allow web server and WireGuard
      allowedTCPPorts = [
        infra.ports.http
        infra.ports.https
        infra.ports.gitea.ssh # Gitea SSH proxy (nginx stream → lab)
        infra.ports.minecraft-server # theboys (nginx stream → lab)
        (infra.ports.minecraft-server + 1) # kj (nginx stream → lab)
      ];
      allowedUDPPorts = [
        infra.vps0.wg0Port # wg0: VPN for personal devices / lab / pi
        infra.vps0.wg1Port # wg1: proxy tunnel to lab and others
      ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };
}
