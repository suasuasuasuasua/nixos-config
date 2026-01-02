{
  # Define the hostname
  networking = {
    hostName = "lab";
    hostId = "d50c497a";
    domain = "sua.sh";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;

      # allow these ports for web server communications
      allowedTCPPorts = [
        80
        443
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
