{
  networking = {
    hostName = "hp-optiplex0";
    domain = "sua.dev";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;
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
