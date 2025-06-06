{
  # Define the hostname
  networking = {
    hostName = "pi";
    hostId = "cfbe2391";
    domain = "suasuasuasuasua.sh";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
    };
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
