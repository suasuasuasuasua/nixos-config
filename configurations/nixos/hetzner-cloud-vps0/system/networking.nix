{ infra, pkgs, ... }:
{
  # Enable UDP GRO forwarding on the physical interface for better Tailscale throughput
  systemd.services.tailscale-udp-gro = {
    description = "Enable UDP GRO forwarding for Tailscale on enp1s0";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp1s0 rx-udp-gro-forwarding on rx-gro-list off";
    };
  };

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
        infra.ports.minecraft-server.theboys # theboys (nginx stream → lab)
        infra.ports.minecraft-server.kj # kj (nginx stream → lab)
      ];
      allowedUDPPorts = [
        infra.vps0.wg1Port # wg1: proxy tunnel to lab and others
        infra.ports.stun # STUN for Headscale embedded DERP (NAT traversal)
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
