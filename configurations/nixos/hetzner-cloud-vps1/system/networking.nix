{ infra, ... }:
{
  networking = {
    hostName = "hetzner-cloud-vps1";
    domain = "sua.dev";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowPing = true;

      allowedUDPPorts = [ infra.vps0.wgPort ];
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
