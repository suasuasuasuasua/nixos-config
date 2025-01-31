{
  networking.firewall = {
    # https://github.com/AdguardTeam/AdGuardHome/wiki/Docker
    # copying these ports
    allowedTCPPorts = [
      53
      68
      80
      443
      853
    ];
    allowedUDPPorts = [
      53
      67
      68
    ];
  };

  services.adguardhome = {
    enable = true;
    # default = 3000
    port = 3000;
    # https://search.nixos.org/options?channel=24.11&show=services.adguardhome.openFirewall&from=0&size=50&sort=relevance&type=packages&query=adguard
    # opens the web port, not the dns port!
    openFirewall = true;
    # TODO: research the settings to automate this process...
    # note that this should not have been empty because it meant that we were
    # clobebring port 80 and not setting a admin account
    # settings = { };
  };
}
