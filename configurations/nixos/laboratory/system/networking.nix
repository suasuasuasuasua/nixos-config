{
  # Define the hostname
  networking.hostName = "laboratory";
  networking.hostId = "d50c497a";

  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # SSH
      22

      # HTTP/S
      80
      443

      # Samba
      139
      445
    ];
    allowedUDPPorts = [
      # Samba
      137
      138
    ];
  };
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = true;
    };
  };
}
