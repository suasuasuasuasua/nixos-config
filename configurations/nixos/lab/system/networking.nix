{ infra, pkgs, ... }:
{
  # Enable UDP GRO forwarding on the physical interface for better Tailscale throughput
  systemd.services.tailscale-udp-gro = {
    description = "Enable UDP GRO forwarding for Tailscale on enp4s0";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.ethtool}/bin/ethtool -K enp4s0 rx-udp-gro-forwarding on rx-gro-list off";
    };
  };

  # Define the hostname
  networking = {
    hostName = "lab";
    hostId = "d50c497a";
    domain = "sua.dev";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;

      # allow these ports for web server communications
      allowedTCPPorts = [
        infra.ports.http
        infra.ports.https
      ];
    };
  };
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      AllowUsers = [ "justinhoang" ];
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };
}
