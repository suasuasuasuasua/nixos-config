{
  # no option to open firewall so do it manually!
  networking.firewall.allowedTCPPorts = [
    9000
  ];

  services.mealie = {
    enable = true;
    # default port = 9000
    port = 9000;
    settings = { };
  };
}
