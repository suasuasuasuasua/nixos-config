{ infra, pkgs, ... }:
{
  # Enable UDP GRO forwarding on the physical interface for better Tailscale throughput
  systemd.services.tailscale-udp-gro = {
    description = "Enable UDP GRO forwarding for Tailscale on end0";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K end0 rx-udp-gro-forwarding on rx-gro-list off";
    };
  };

  networking = {
    hostName = "pi";
    hostId = "cfbe2391";
    domain = "sua.dev";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        infra.ports.http
        infra.ports.https
      ];
    };
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "admin" ];
      PasswordAuthentication = false;
    };
  };
}
