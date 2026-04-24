{
  networking = {
    hostName = "hetzner-cloud-vps0";
    domain = "sua.dev";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;

      # Allow web server and WireGuard
      allowedTCPPorts = [
        80
        443
        2222 # Gitea SSH proxy (nginx stream → lab)
      ];
      allowedUDPPorts = [ 51820 ];
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
