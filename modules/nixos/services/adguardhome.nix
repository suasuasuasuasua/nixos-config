{
  services.adguardhome = {
    enable = true;
    # default = 3000
    port = 3000;
    openFirewall = true;
    # TODO: research the settings to automate this process...
    # note that this should not have been empty because it meant that we were
    # clobebring port 80 and not setting a admin account
    # settings = { };
  };
}
